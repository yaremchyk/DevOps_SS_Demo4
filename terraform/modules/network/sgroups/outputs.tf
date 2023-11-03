output "security_group_ec2_id" {
  value = aws_security_group.ec2.id
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "security_group_db_id" {
  value = aws_security_group.db.id
}

output "security_group_ec2" {
  value = aws_security_group.ec2
}

output "security_group_alb" {
  value = aws_security_group.alb
}

output "security_group_db" {
  value = aws_security_group.db
}

output "security_group_bastion_host_id" {
  value = aws_security_group.bastion_host.id
}