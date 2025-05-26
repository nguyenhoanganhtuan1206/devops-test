# Security group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.app_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.devops_test_vpc.id
}

# ----------------------------------------------------------
# ALB app Security Group Rules - INBOUND
# ----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow http inbound traffic from internet"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow https inbound traffic from internet"
}

resource "aws_vpc_security_group_ingress_rule" "alb_port_appl" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  description       = "Application port from anywhere"
}

# ----------------------------------------------------------
# ALB app Security Group Rules - OUTBOUND
# ----------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "alb_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic from ALB"
}

# Security group for ECS Tasks
resource "aws_security_group" "ecs_sg" {
  name        = "${var.app_name}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.devops_test_vpc.id
}

# ----------------------------------------------------------
# ECS app Security Group Rules - INBOUND
# ----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "ecs_alb_ingress" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  ip_protocol                  = "-1"
  description                  = "Allow incoming traffic from ALB"
}
# ----------------------------------------------------------
# ECS app Security Group Rules - OUTBOUND
# ----------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "ecs_all_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}