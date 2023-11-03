variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}


variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "domain_name" {
  type = string
  default = "yaremchyk.pp.ua"
}

variable "route53_zone_id" {
  type = string
  default = "Z091290221DJ8B3NJO3W5"
}

variable "environment" {
  description = "Environment for deployment"
  default     = "staging"
  type        = string
}

variable "security_group_alb_id" {
  type        = string
}

variable "healthcheck_endpoint" {
  description = "Endpoint for ALB healthcheck"
  type        = string
  default     = "/"
}

variable "healthcheck_matcher" {
  description = "HTTP status code matcher for healthcheck"
  type        = string
  default     = "200"
  
}
