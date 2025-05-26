# Defining ALB
resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.devops-test_subnet-1.id, aws_subnet.devops-test_subnet-2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

# Definining the target group and a health check on the application.
resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-tg"
  vpc_id      = aws_vpc.devops_test_vpc.id
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
}

# Define HTTP listener for ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}