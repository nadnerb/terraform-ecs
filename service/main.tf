provider "aws" {
  region = "${var.region}"
}

resource "aws_ecs_service" "default" {
  name = "${var.ecs_service_name}"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count = "${var.service_desired_count}"
}

resource "aws_ecs_task_definition" "default" {
  family = "${var.ecs_service_name}"
# TODO document this!
  container_definitions = "${file("${var.config_location}/definitions/${var.environment}.json")}"
  volume {
    name = "${var.ecs_service_name}"
    host_path = "/ecs/${var.ecs_service_name}"
  }
}

