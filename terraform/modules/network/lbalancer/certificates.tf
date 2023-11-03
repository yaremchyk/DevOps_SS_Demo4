resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}", var.domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate" {
  allow_overwrite = true
  name    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_type
  zone_id = var.route53_zone_id
  records = [tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cert_validate" {
  certificate_arn = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate.fqdn]
}