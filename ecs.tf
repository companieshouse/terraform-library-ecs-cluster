resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.name_prefix}-cluster"
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.test.arn
    weight = 1
  }
  depends_on = [
    aws_ecs_capacity_provider.test.arn
  ]
}
