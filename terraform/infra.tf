data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {}

resource "aws_security_group" "int_alb_sg" {
    name        = "int-alb-sg"
    description = "Security group for internal networks"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["127.0.0.1/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "alb_internal" {
  name               = "int-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.int_alb_sg.id]
  subnets            = data.aws_subnets.default.ids
  idle_timeout       = 120

  enable_deletion_protection = false

  tags = {
    Name        = "int-alb"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_lb_listener" "alb_internal_http" {
  load_balancer_arn = aws_lb.alb_internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default_internal.arn
  }
}


resource "aws_lb_target_group" "default_internal" {
  name     = "default-internal-dev"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    protocol            = "HTTP"
    path                = "/health_check"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }

  tags = {
    Name      = "default-internal"
    Default   = "true"
    Terraform = "true"
  }
}


resource "aws_lb_listener_rule" "redirect_http_internal" {
  listener_arn = aws_lb_listener.alb_internal_http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["localhost/*"]
    }
  }
}
