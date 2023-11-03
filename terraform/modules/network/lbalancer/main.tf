resource "aws_alb" "alb" {
  name            = "${var.namespace}-alb-${var.environment}"
  security_groups = [var.security_group_alb_id]
  subnets         = var.public_subnets
}

resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.alb_certificate.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }
  depends_on = [aws_acm_certificate.alb_certificate]
}

resource "aws_lb_listener_certificate" "alb_default_listener_certificate_https" {
  depends_on = [aws_acm_certificate_validation.cert_validate]

  listener_arn    = aws_alb_listener.alb_default_listener_https.arn
  certificate_arn = "${aws_acm_certificate.alb_certificate.arn}"
}

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.namespace}-target-group-${var.environment}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 5

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = var.healthcheck_matcher
    path                = var.healthcheck_endpoint
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }
  depends_on = [aws_alb.alb]
}