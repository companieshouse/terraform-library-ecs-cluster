locals {
  # test values hardcoded here
  environment = "tflibtest"
  stack_name  = "lib-ecs-test"
  name_prefix = "${local.stack_name}-${local.environment}"

  aws_region        = "eu-west-2"
  ecs_key_pair_name = "stack-pocs"
  instance_type     = "t3.micro"
  image_id          = "ami-0f49b2a9014635082" # ECS optimized Amazon Linux in London created 10/07/2019
  max_instance_size = 1
  min_instance_size = 1
  desired_capacity  = 1
}

provider "aws" {
  region  = local.aws_region
  version = "~> 2.32.0"
}

terraform {
  backend "s3" {
  }
}

# Get default VPC and subnets to keep test simple rather than using netowkrs remote state
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

module "ecs-cluster" {
  source = "../" # up to root of repo

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = local.environment

  vpc_id            = "${data.aws_vpc.default.id}"
  ecs_key_pair_name = local.ecs_key_pair_name
  instance_type     = local.instance_type
  image_id          = local.image_id
  max_instance_size = local.max_instance_size
  min_instance_size = local.min_instance_size
  desired_capacity  = local.desired_capacity
  application_ids   = "${join(",", data.aws_subnet_ids.all.ids)}"
}
