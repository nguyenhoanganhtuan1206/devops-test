resource "aws_ecr_repository" "devops_test_ecr" {
  name = "${var.app_name}-ecr"

  image_scanning_configuration {
    scan_on_push = true
  }
}
