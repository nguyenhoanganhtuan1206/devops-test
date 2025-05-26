
# IAM role ECS task role
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.app_name}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assum_role_policy.json

  tags = {
    Name = "${var.app_name}-ecs-task-role"
  }
}

# Assume role policy for ECS tasks
data "aws_iam_policy_document" "assum_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# IAM role ECS execution role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.app_name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assum_role_policy.json

  tags = {
    Name = "${var.app_name}-ecs-execution-role"
  }
}

# Attach AmazonECSTaskExecutionRolePolicy to execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom ECR policy for execution role
resource "aws_iam_policy" "ecs_execution_ecr_policy" {
  name        = "${var.app_name}-ecs-execution-ecr-policy"
  description = "ECR permissions for ECS task execution role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach custom ECR policy to execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_ecr_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_ecr_policy.arn
}

# Attach existing policy to task role (optional, based on your needs)
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}