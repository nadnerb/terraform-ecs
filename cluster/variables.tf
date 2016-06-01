variable "role_tag" {
  description = "Role of the ec2 instance, defaults to <SERVICE>"
  default = "SERVICE"
}

variable "environment_tag" {
  description = "Role of the ec2 instance, defaults to <DEV>"
  default = "DEV"
}

variable "costcenter_tag" {
  description = "Role of the ec2 instance, defaults to <DEV>"
  default = "DEV"
}

# group our resources
variable "stream_tag" {
  default = "default"
}

variable "environment" {
  default = "default"
}

###################################################################
# AWS configuration below
###################################################################

variable "availability_zones" {
  description = "The availability zones"
  default = "ap-southeast-2a,ap-southeast-2b"
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "ap-southeast-2"
}

# REQUIRED
variable "ami" {
}

# REQUIRED
variable "ecs_iam_profile_id" {
}

# REQUIRED
variable "key_name" {
  description = "The aws ssh key name."
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
  description = "VPC which the ec2 instances will be created"
  default = ""
}

variable "subnets" {
  description = "Subnets where the ec2 instances should be launched"
  default = ""
}

variable "additional_security_groups" {
  default = ""
}

variable "internal_cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "default"
}

###################################################################
# AWS autoscaling
###################################################################
variable "ecs_auto_scaling_min_size" {
  default = 1
  description = "minimum instances to run in the ecs cluster"
}

variable "ecs_auto_scaling_max_size" {
  default = 5
  description = "maximum instances to run in the ecs cluster"
}

variable "ecs_auto_scaling_desired_size" {
  default = 1
  description = "desired size of the cluster"
}
