output "ecr image url" {
  value = "${aws_ecr_repository.default.registry_id}.dkr.ecr.us-east-1.amazonaws.com/${aws_ecr_repository.default.name}"
}

output "arn" {
  value = "${aws_ecr_repository.default.arn}"
}
