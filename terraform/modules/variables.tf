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