// ---- Security Group ----
resource "aws_security_group" "ec2-security-group" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = "${var.vpc_id}"

  // HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Application well known container ports
  ingress {
    from_port   = 9000
    to_port     = 11000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // ECS Auto-Assigned Host Ports in the linux kernel epehemeral port range
  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// ---- Launch Configuration ----
resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                        = "${var.name_prefix}-ecs-lc"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.name
  security_groups             = ["${aws_security_group.ec2-security-group.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.ecs_key_pair_name}"
  user_data = templatefile(
    "${path.module}/ec2-user-data.tmpl",
    {
      ecs_cluster_name : aws_ecs_cluster.ecs-cluster.name
    }
  )
}

//---- Auto Scaling Group ----
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "${var.name_prefix}-ecs-asg"
  max_size             = "${var.max_instance_size}"
  min_size             = "${var.min_instance_size}"
  desired_capacity     = "${var.desired_capacity}"
  vpc_zone_identifier  = flatten([split(",", var.application_ids)])
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type    = "ELB"

  tags = [
    {
      key                 = "Name"
      value               = "${var.name_prefix}-ecs-instance"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    }
  ]
}
