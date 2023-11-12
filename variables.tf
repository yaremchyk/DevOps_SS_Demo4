variable "env" {
  type    = string
  default = "dev"
}

variable "app_name" {
  default = "todo"
}

locals {
  tags = {
    Environment = var.env
  }
}

# ===================NETWORK=======================

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

# ===================ECR=======================

variable "repository_name" {
  type    = string
  default = "dev/demo3"
}

# ===================ALB=======================

variable "lb_name" {
  type    = string
  default = "jenkins-demo-lb"
}

variable "tg_name" {
  type    = string
  default = "jenkins-tg"
}

variable "domain" {
  type    = string
  default = "yaremchyk.pp.ua"
}


# ===================EKS=======================

variable "cluster_name" {
  type    = string
  default = "demo-cluster"
}
