variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for deployment"
  default     = "staging"
  type        = string
}