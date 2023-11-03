output "dns_name" {
    value = aws_alb.alb.dns_name
}

output "zone_id" {
    value = aws_alb.alb.zone_id
}

output "service_target_group_arn" {
  value = aws_alb_target_group.service_target_group.arn
}