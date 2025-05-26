# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-cluster"
}

# Task definition
resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.app_name}-task-family"

  container_definitions = jsonencode([
    {
      name  = "${var.app_name}-container"
      image = "${data.aws_ecr_repository.devops_test_ecr_name.repository_url}:latest"
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval    = 30
        timeout     = 5
        startPeriod = 10
        retries     = 3
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}"
          "awslogs-region"        = "${var.aws_region}"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name                = "${var.app_name}-service"
  cluster             = aws_ecs_cluster.ecs_cluster.arn
  task_definition     = aws_ecs_task_definition.task_definition.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 2

  # Networking
  network_configuration {
    subnets = [
      aws_subnet.devops-test_subnet-1.id,
      aws_subnet.devops-test_subnet-2.id
    ]
    security_groups = [
      aws_security_group.ecs_sg.id,
      aws_security_group.alb_sg.id
    ]
    assign_public_ip = true
  }

  # Load balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-container"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.listener]
}