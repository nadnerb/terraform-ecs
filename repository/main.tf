provider "aws" {
  region = "${var.ecr_region}"
}
/* ecr repo */
resource "aws_ecr_repository" "default" {
  name = "${var.ecr_repo_name}"
}
