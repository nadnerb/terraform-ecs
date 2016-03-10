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

## REQUIRED ##
variable "ecs_cluster_name"{
  description = "ecs cluster with with to run the service"
}

## REQUIRED ##
variable "ecs_service_name" {
  description = "ecs service name"
}

variable "service_desired_count"{
  default = 1
  description = "desired number indexer service's stack count"
}

## REQUIRED ##
variable "public_hosted_zone_id" {
  description = "Route 53 hosted zone id"
}

## REQUIRED ##
variable "public_hosted_zone_name" {
  description = "Route 53 hosted zone id"
}

## REQUIRED ##
variable "vpc_id" {
}

## REQUIRED ##
variable "elb_subnets" {
}

## REQUIRED ##
variable "availability_zones" {
}

## REQUIRED ##
variable "container_name" {
}

## REQUIRED ##
variable "container_port" {
}
