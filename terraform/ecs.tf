resource "aws_ecs_cluster" "my_cluster" {
  name = "my_cluster"
}

resource "aws_ecs_task_definition" "echo_python" {
  family                   = "echo_python"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "2048"
  cpu                      = "1024"

  container_definitions = jsonencode([{
    name      = "echo_python"
    image     = "010928223552.dkr.ecr.us-east-1.amazonaws.com/echo_python:latest"
    essential = true
    portMappings = [{
      containerPort = 3246
      hostPort      = 3246
    }]
  }])
}

resource "aws_ecs_service" "echo_python" {
  name            = "echo_python"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.echo_python.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0b07d9267a7cdea44"]  # substitua pelo seu subnet ID
    security_groups = ["sg-08c8bbed11ace906d"]      # substitua pelo seu security group ID
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "echo_python"
    container_port   = 3246
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0eac20740568ca2ff"  # substitua pelo seu VPC ID

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb" "lb" {
  name               = "int-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-08c8bbed11ace906d"]  # substitua pelo seu security group ID
  subnets            = ["subnet-0b07d9267a7cdea44", "subnet-0a157b28b6633dcec"]  # substitua pelos seus subnet IDs
}
