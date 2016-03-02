/* ecs iam role and policies */
resource "aws_iam_role" "ecs_role" {
  name               = "${var.ecs_cluster_name}-ecs-role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

/* ecs service scheduler role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name     = "${var.ecs_cluster_name}-ecs-service-role-policy"
  policy   = "${file("policies/ecs-service-role-policy.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}

/* ec2 container instance role & policy */
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name     = "${var.ecs_cluster_name}-ecs-instance-role"
  policy   = "${file("policies/ecs-instance-role-policy.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}

/* ec2 container instance policy to access ecr */
resource "aws_iam_role_policy" "ecs_ecr_role_policy" {
  name     = "${var.ecs_cluster_name}-ecs-ecr-role-policy"
  policy   = "${file("policies/ecs-ecr-role-policy.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}

/**
 * IAM profile to be used in auto-scaling launch configuration.
 */
resource "aws_iam_instance_profile" "ecs" {
  # associate with the role by name (see aws docs)
  name = "${var.ecs_cluster_name}-ecs-instance-role"
  path = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}
