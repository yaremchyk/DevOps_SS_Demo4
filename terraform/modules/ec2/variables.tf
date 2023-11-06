variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for deployment"
  default     = "staging"
  type        = string
}

variable "key_pair_name" {
  default = "ssh-key-pair"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_subnet_id" {
  type = string
}

variable "security_group_bastion_host_id" {
  type = string
}