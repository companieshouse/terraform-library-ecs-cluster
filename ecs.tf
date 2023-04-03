resource "aws_ecs_cluster" "ecs-cluster" {
  count = "${var.container_insights_enablement == 1 ? 1 : 0}"
  name = "${var.name_prefix}-cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insights_enablement
  }
}
