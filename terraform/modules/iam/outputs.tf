output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}

output "ec2_instance_role_profile_arn" {
  value = aws_iam_instance_profile.ec2_instance_role_profile.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_iam_role_arn" {
  value = aws_iam_role.ecs_task_iam_role.arn
}