provider "aws" {
  region = "${var.region}"
}

resource "aws_ecs_service" "default" {
  name = "${var.ecs_service_name}"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count = "${var.service_desired_count}"
  iam_role = "${aws_iam_role.ecs_agent_role.name}"

  load_balancer {
    elb_name = "${aws_elb.default.id}"
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
  }
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

resource "aws_security_group" "elb" {
  name = "${var.ecs_cluster_name}-ecs-elb-sg"
  description = "${var.ecs_cluster_name} elb ecs security group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    /*cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]*/
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.ecs_cluster_name}-ecs-sg"
    Stream = "${var.stream_tag}"
  }
}

resource "aws_elb" "default" {
  name = "${var.ecs_service_name}-ecs-elb"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets = ["${split(",", var.elb_subnets)}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.ecs_service_name}-elb"
    Stream = "${var.stream_tag}"
  }
  tags {
    key = "Stream"
    value = "${var.stream_tag}"
  }
  tags {
    key = "ServerRole"
    value = "ECS"
  }
  tags {
    key = "Cost Center"
    value = "${var.costcenter_tag}"
  }
  tags {
    key = "Environment"
    value = "${var.environment_tag}"
  }

  listener {
    instance_port = "${var.container_port}"
    lb_port = 80
    instance_protocol = "http"
    lb_protocol = "http"
  }
}

resource "aws_route53_record" "public" {
  zone_id = "${var.public_hosted_zone_id}"
  name = "${var.public_hosted_zone_name}"
  type = "A"

  alias {
    name = "${aws_elb.default.dns_name}"
    zone_id = "${aws_elb.default.zone_id}"
    evaluate_target_health = true
  }
}
