data "aws_ecr_repository" "devops_test_ecr_name" {
  name = "${var.app_name}-ecr"
}