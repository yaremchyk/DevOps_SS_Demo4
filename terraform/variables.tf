variable "region" {
  type    = string
  default = "us-east-1"
}

variable "namespace" {
  type    = string
  default = "dev"
}

variable "service_name" {
  type    = string
  default = "demo3"
}

variable "key_pair_name" {
  default = "ssh-key-pair"
}

variable "route53_zone_id" {
  type    = string
  default = "Z091290221DJ8B3NJO3W5"
}

variable "secret_name" {
    type = string
    default = "Demo3/Creds"
}

variable "ec2_instance_role_profile_arn" {
    type = string
    default = "arn:aws:iam::025389115636:role/dev-ec2-instance-role-profile-staging"
}

variable "aws_worker_profile" {
  description = "The AWS default worker profile"
  default     = "demo4"
}

variable "ecr_rep" {
  description = "Name of ECR"
  default     = "dev/demo3"
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  default     = "demo4"
}

variable "alb_name" {
  description = "Name of ALB"
  default     = "public-lb"
}

variable "hosted_zone_name" {
  description = "Name of hosted zone on Route 53"
  default     = "yaremchyk.pp.ua"
}

variable "cloud_tech_demo_tags" {
  description = "Default cloud-tech-demo tags"
  default = {
    Application = "demo4"
    Owner       = "yarema"
    Environment = "test"
  }
}

variable "kms_key_arn" {
  description = "AWS KMS Key ARN"
}

variable "vpc_name" {
  description = "Name of VPC"
  default     = "main"
}