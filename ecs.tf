resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.name_prefix}-cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insights_enablement
  }
}
