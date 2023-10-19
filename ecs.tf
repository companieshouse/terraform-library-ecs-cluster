resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.name_prefix}-cluster"
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_capacity_provider" "ec2_capacity_provider" {
  count = var.enable_asg_autoscaling ? 1 : 0
  name  = "capacity-provider-${var.name_prefix}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-autoscaling-group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 150
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  count              = var.enable_asg_autoscaling ? 1 : 0
  cluster_name       = aws_ecs_cluster.ecs-cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ec2_capacity_provider[0].name, "FARGATE"]

  # default to using EC2 if no capacity provider strategy is defined for a service
  default_capacity_provider_strategy {
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ec2_capacity_provider[0].name
  }
}