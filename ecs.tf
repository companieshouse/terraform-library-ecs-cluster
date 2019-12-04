resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.name_prefix}-cluster"
}
