/* ecs iam role and policies */
resource "aws_iam_role" "ecs_agent_role" {
  name               = "${var.ecs_service_name}_ecs_role"
  assume_role_policy = "${file("policies/ecs-agent-role.json")}"
}

/* ecs service agent role to talk to load balancer */
resource "aws_iam_role_policy" "ecs_service_agent_role_policy" {
  name     = "${var.ecs_service_name}_ecs_service_agent_role_policy"
  policy   = "${file("policies/ecs-service-agent-role-policy.json")}"
  role     = "${aws_iam_role.ecs_agent_role.id}"
}

