//----------------------------------------------------------------------
// Shared Variables
//----------------------------------------------------------------------

variable "stack_name" {}
variable "name_prefix" {}
variable "environment" {}
variable "vpc_id" {}
variable "application_ids" {}
variable "ecs_key_pair_name" {}

//----------------------------------------------------------------------
// Autoscaling Group Variables
//----------------------------------------------------------------------

variable "max_instance_size" {
  description = "The name for the autoscaling group for the cluster."
  default     = 4
}

variable "min_instance_size" {
  description = "The name for the autoscaling group for the cluster."
  default     = 2
}

variable "desired_capacity" {
  description = "The name for the autoscaling group for the cluster."
  default     = 3
}

//----------------------------------------------------------------------
// Launch Configuration Variables
//----------------------------------------------------------------------

variable "image_id" {
  description = "The name for the autoscaling group for the cluster."
  default     = "ami-0f49b2a9014635082" # ECS optimized Amazon Linux in London created 10/07/2019
}

variable "instance_type" {}
