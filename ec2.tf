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
    cidr_blocks = split(",", var.ec2_ingress_cidr_blocks)
    security_groups = [var.ec2_ingress_sg_id]
  }

  // HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = split(",", var.ec2_ingress_cidr_blocks)
  }

  // SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = split(",", var.ec2_ingress_cidr_blocks)
  }

  // Application well known container ports
  ingress {
    from_port   = 9000
    to_port     = 11000
    protocol    = "tcp"
    cidr_blocks = split(",", var.ec2_ingress_cidr_blocks)
  }

  // ECS Auto-Assigned Host Ports in the linux kernel epehemeral port range
  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = split(",", var.ec2_ingress_cidr_blocks)
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
  name_prefix                 = "${var.name_prefix}-"
  image_id                    = "${var.ec2_image_id}"
  instance_type               = "${var.ec2_instance_type}"
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.name
  security_groups             = ["${aws_security_group.ec2-security-group.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.ec2_key_pair_name}"
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
  max_size             = "${var.asg_max_instance_count}"
  min_size             = "${var.asg_min_instance_count}"
  desired_capacity     = "${var.asg_desired_instance_count}"
  vpc_zone_identifier  = split(",", var.application_subnet_ids)
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type    = "ELB"
  protect_from_scale_in = "true"

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

resource "aws_ecs_capacity_provider" "test" {
  name = "example"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-autoscaling-group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}
