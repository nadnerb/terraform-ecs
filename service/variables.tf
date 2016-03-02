variable "region" {
  description = "The AWS region to create resources in."
  default = "ap-southeast-2"
}

variable "environment" {
  description = "Name of the service, also can be passed in via terraform_exec"
  default = "default"
}

variable "config_location" {
  description = "location of definitions, needs to be var.config_location/definitions"
}

variable "ecs_cluster_name"{
  description = "ecs cluster with with to run the service"
}

variable "ecs_service_name" {
  description = "ecs service name"
}

variable "service_desired_count"{
  default = 1
  description = "desired number indexer service's stack count"
}
