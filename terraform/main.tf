provider "aws" {
  region = "eu-north-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnets
resource "aws_subnet" "subnet" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = "10.0.1.0/24"
  availability_zone  = "eu-north-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = "10.0.2.0/24"
  availability_zone  = "eu-north-1b"
}

resource "aws_subnet" "subnet3" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = "10.0.3.0/24"
  availability_zone  = "eu-north-1c"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.route_table.id
}

# Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECR Repositories
resource "aws_ecr_repository" "web" {
  name = "web"
}

resource "aws_ecr_repository" "django" {
  name = "django"
}

resource "aws_ecr_repository" "frontend" {
  name = "frontend"
}

# ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "my-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::058264232850:role/ecsTaskExecutionRole"  # Replace with your existing IAM role ARN

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "058264232850.dkr.ecr.eu-north-1.amazonaws.com/web"
      essential = true
      portMappings = [
        {
          containerPort = 8000
        }
      ]
    },
    {
      name      = "django"
      image     = "058264232850.dkr.ecr.eu-north-1.amazonaws.com/django"
      essential = true
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    },
    {
      name      = "frontend"
      image     = "058264232850.dkr.ecr.eu-north-1.amazonaws.com/frontend"
      essential = true
      portMappings = [
        {
          containerPort = 3000
        }
      ]
    }
  ])
}

# Application Load Balancer
resource "aws_alb" "app" {
  name               = "load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [
    aws_subnet.subnet.id,
    aws_subnet.subnet2.id,
    aws_subnet.subnet3.id
  ]
}

# Target Groups
resource "aws_lb_target_group" "web_tg" {
  name         = "web-tg"
  port         = 8000
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_target_group" "django_tg" {
  name         = "django-tg"
  port         = 8080
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_target_group" "frontend_tg" {
  name         = "frontend-tg"
  port         = 3000
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

# Load Balancer Listener for HTTP traffic
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Load Balancer Listeners for applications
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_alb.app.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener" "django_listener" {
  load_balancer_arn = aws_alb.app.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django_tg.arn
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_alb.app.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 5

  network_configuration {
    subnets         = [
      aws_subnet.subnet.id,
      aws_subnet.subnet2.id,
      aws_subnet.subnet3.id
    ]
    security_groups = [aws_security_group.sg.id]
    assign_public_ip = false 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "web"
    container_port   = 8000
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.django_tg.arn
    container_name   = "django"
    container_port   = 8080
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "frontend"
    container_port   = 3000
  }
}

output "app_url" {
  value = aws_alb.app.dns_name
}
