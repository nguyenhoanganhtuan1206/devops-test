variable "app_name" {
  description = "Name of the application"
  default     = "devops-test"
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "app_port" {
  default = 3000
}