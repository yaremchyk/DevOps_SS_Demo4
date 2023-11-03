variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for deployment"
  default     = "staging"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "internet_gateway_id" {
  type = string
}

variable "az_count" {
  description = "Describes how many availability zones are used"
  default     = 2
  type        = number
}

variable "vpc_cidr_block" {
  type        = string
}