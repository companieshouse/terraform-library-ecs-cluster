//----------------------------------------------------------------------
// Standard Variables
//----------------------------------------------------------------------
variable "stack_name" {
  description = "The name of the infrastructure 'stack' this cluster is part of."
  type        = "string"
}
variable "environment" {
  description = "The name of the environment this cluster is part of e.g. live, staging, dev. etc."
  type        = "string"
}
variable "name_prefix" {
  description = "The prefix to use when naming resources in this cluster. Usually a combination of environment and stack_name for concistency e.g. '{stack_name}-{environment}'."
  type        = "string"
}

//----------------------------------------------------------------------
// Networking Variables
//----------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC to deploy resources into."
  type        = "string"
}
variable "subnet_ids" {
  description = "Comma seperated list of subnet ids to deploy the cluster into."
  type        = "string"
}

//----------------------------------------------------------------------
// Auto Scaling Group Variables
//----------------------------------------------------------------------
variable "asg_max_instance_count" {
  description = "The maximum allowed number of instances in the autoscaling group for the cluster."
  type        = number
  default     = 3
}

variable "asg_min_instance_count" {
  description = "The minimum allowed number of instances in the autoscaling group for the cluster."
  type        = number
  default     = 1
}

variable "asg_desired_instance_count" {
  description = "The desired number of instances in the autoscaling group for the cluster. Must fall within the min/max instance count range."
  type        = number
  default     = 2
}

//----------------------------------------------------------------------
// EC2 Launch Configuration Variables
//----------------------------------------------------------------------
variable "ec2_key_pair_name" {
  description = "The ec2 key pair name for SSH access to ec2 instances in the clusters auto scaling group."
  type        = "string"
  default     = "" # Empty string implies no key pair should be used so no SSH access is available on the instances
}
variable "ec2_image_id" {
  description = "The name for the autoscaling group for the cluster."
  type        = "string"
  default     = "ami-0f49b2a9014635082" # ECS optimized Amazon Linux in London created 10/07/2019
}
variable "ec2_instance_type" {
  description = "The ec2 instance type for ec2 instances in the clusters auto scaling group."
  type        = "string"
  default     = "t3.micro"
}
variable "ec2_ingress_cidr_blocks" {
  description = "Comma seperated list of ingress CIDR ranges to allow access to application ports."
  type        = "string"
  default     = "0.0.0.0/0"
}
variable "ec2_ingress_sg_id" {
  description = "The security groups from which to allow access to port 80."
  type        = list(string)
  default     = []
}
