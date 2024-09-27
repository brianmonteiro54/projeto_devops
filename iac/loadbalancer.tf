# Load Balancer
resource "aws_lb" "production" {
  name               = "production"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_production.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
  ip_address_type            = "ipv4"

  tags = {
    Name        = "production"
    Environment = "Production"
  }
}

# Listener HTTP (port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.production.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}" # Mantém o host original
      path        = "/"
      query       = "#{query}" # Mantém a query string original
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Target Group
resource "aws_lb_target_group" "ecs_api" {
  name        = "ecs-api"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform_vpc.id
  target_type = "ip"

  deregistration_delay = 20

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs-api"
  }
}

# Listener HTTPS (port 443)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.production.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.domain_cert.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_api.arn
  }
}

# Registro no Route 53
resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id # Usando a zona existente
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.production.dns_name
    zone_id                = aws_lb.production.zone_id
    evaluate_target_health = true
  }
}