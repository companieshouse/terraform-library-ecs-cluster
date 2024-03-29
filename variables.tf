//----------------------------------------------------------------------
// Standard Variables
//----------------------------------------------------------------------
variable "stack_name" {
  description = "The name of the infrastructure 'stack' this cluster is part of."
  type        = string
}
variable "environment" {
  description = "The name of the environment this cluster is part of e.g. live, staging, dev. etc."
  type        = string
}
variable "name_prefix" {
  description = "The prefix to use when naming resources in this cluster. Usually a combination of environment and stack_name for concistency e.g. '{stack_name}-{environment}'."
  type        = string
}

//----------------------------------------------------------------------
// Networking Variables
//----------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC to deploy resources into."
  type        = string
}
variable "subnet_ids" {
  description = "Comma seperated list of subnet ids to deploy the cluster into."
  type        = string
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

variable "scaledown_schedule" {
  description = "The schedule to use when scaling down the number of EC2 instances to zero."
  # Typically used to stop all instances in a cluster to save resource costs overnight.
  # E.g. a value of '00 20 * * 1-7' would be Mon-Sun 8pm.  An empty string indicates that no schedule should be created.

  type        = string
  default     = ""
}

variable "scaleup_schedule" {
  description = "The schedule to use when scaling up the number of EC2 instances to their normal desired level."
  # Typically used to start all instances in a cluster after it has been shutdown overnight.
  # E.g. a value of '00 06 * * 1-7' would be Mon-Sun 6am.  An empty string indicates that no schedule should be created.

  type        = string
  default     = ""
}

variable "enable_asg_autoscaling" {
  description = "Whether to enable auto-scaling of the ASG by creating a capacity provider for the ECS cluster."
  type        = bool
  default     = false
}

variable "maximum_scaling_step_size" {
  description = "The maximum number of Amazon EC2 instances that Amazon ECS will scale out at one time.  Total is limited by asg_max_instance_count too."
  type        = number
  default     = 150
}

variable "minimum_scaling_step_size" {
  description = "The minimum number of Amazon EC2 instances that Amazon ECS will scale out at one time."
  type        = number
  default     = 1
}

variable "target_capacity" {
  description = "The target capacity utilization as a percentage for the capacity provider."
  type        = number
  default     = 100
}

//----------------------------------------------------------------------
// EC2 Launch Configuration Variables
//----------------------------------------------------------------------
variable "ec2_key_pair_name" {
  description = "The ec2 key pair name for SSH access to ec2 instances in the clusters auto scaling group."
  type        = string
  default     = "" # Empty string implies no key pair should be used so no SSH access is available on the instances
}
variable "ec2_image_id" {
  description = "The name for the autoscaling group for the cluster."
  type        = string
  default     = "ami-0f49b2a9014635082" # ECS optimized Amazon Linux in London created 10/07/2019
}
variable "ec2_instance_type" {
  description = "The ec2 instance type for ec2 instances in the clusters auto scaling group."
  type        = string
  default     = "t3.micro"
}
variable "ec2_ingress_cidr_blocks" {
  description = "Comma seperated list of ingress CIDR ranges to allow access to application ports."
  type        = string
  default     = "0.0.0.0/0"
}
variable "ec2_ingress_sg_id" {
  description = "The security groups from which to allow access to port 80."
  type        = list(string)
  default     = []
}

//----------------------------------------------------------------------
// ECS Cluster Variables
//----------------------------------------------------------------------
variable "enable_container_insights" {
  description = "A boolean value indicating whether to enable Container Insights or not"
  type        = bool
  default     = false
}
