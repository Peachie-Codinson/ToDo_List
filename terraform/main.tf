provider "aws" {
  region = "eu-north-1"
}

# Data source for availability zones
data "aws_availability_zones" "available" {}

# Define the VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Define the existing Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Define subnets
resource "aws_subnet" "subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

# Define a security group
resource "aws_security_group" "allow_ports" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define an Application Load Balancer
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ports.id]
  subnets            = aws_subnet.subnet[*].id
}

# Define a target group for the ALB
resource "aws_lb_target_group" "main" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Define a listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

# Outputs
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.allow_ports.id
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}
