provider "aws" {
  region = "${var.region}"
}

/* ecs service cluster */
resource "aws_ecs_cluster" "default" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_security_group" "ecs" {
  name = "${var.ecs_cluster_name}-ecs-sg"
  description = "${var.ecs_cluster_name} ECS Container Ports"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs-sg"
    Stream = "${var.stream_tag}"
  }
}

/**
 * Launch configuration used by autoscaling group
 */
resource "aws_launch_configuration" "ecs" {
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  security_groups      = ["${split(",", replace(concat(aws_security_group.ecs.id, ",", var.additional_security_groups), "/,\\s?$/", ""))}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }
}

/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "ecs" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = "${var.ecs_auto_scaling_min_size}"
  max_size             = "${var.ecs_auto_scaling_max_size}"
  desired_capacity     = "${var.ecs_auto_scaling_desired_size}"
  vpc_zone_identifier  = ["${split(",", var.subnets)}"]

  tag {
    key = "Name"
    value = "${var.ecs_cluster_name}-ecs-instance"
    propagate_at_launch = true
  }
  tag {
    key = "Stream"
    value = "${var.stream_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "ServerRole"
    value = "ECS"
    propagate_at_launch = true
  }
  tag {
    key = "Cost Center"
    value = "${var.costcenter_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment_tag}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

