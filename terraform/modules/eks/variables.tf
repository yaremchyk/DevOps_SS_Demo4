variable "region" {
  #default region to deploy infrastructure
  type    = string
  default = "us-east-1"
}

variable "environment" {
  #default environment to tag infrastructure
  type    = string
  default = "demo4"
}

variable "eks_name" {
  #name for eks cluster
  type    = string
  default = "demo4"
}

variable "tags" {
  #tags for eks cluster
  type    = map(string)
  default = {"env" = "demo4"}
}

variable "env_name" {
  #environment name for eks cluster
  type    = string
  default = "demo4"
}

variable "alb_tag" {
  #alb tag for data to retrieve
  type = map(string)
  default = {
    MyController = "true"
  }
}

variable "domain" {
  description = "Domain name for hosted zone"
  default = "yaremchyk.pp.ua"
  type = string
}