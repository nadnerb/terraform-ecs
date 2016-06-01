Amazon ECS using Terraform
=============

## Requirements

* Terraform >= v0.6.12

## Installation

* install [Terraform](https://www.terraform.io/) and add it to your PATH.
* clone this repo.

## IAM

Setting up the IAM policy for the `cluster`. This should only need to be done once per cluster in AWS account. You could also share the same role for all clusters, however they may have slightly different policies, this could be pulled out as configuration.

## Repository

The ECR repository for the cluster should only need to be done once per AWS account. All clusters in all regions can share the same containers.

## Cluster

The ec2 and autoscaling setup for the ECS cluster.

## SERVICES

Any services running in the cluster. The configuration requires the task definition to be in:

`config_location/definitions`

This can be modified in the service/main.tf file:

```
  container_definitions = "${file("${var.config_location}/definitions/${var.environment}.json")}"
```

## WEBSERVICES

Similar to services except also includes an ELB.

## TODO

* Pull out policy so that it can be provided as configuration similar to task definitions.
* Further documentation and configuration examples.

## Acknowledgements

Thanks PK (humblelistener) for initally setting this up.
