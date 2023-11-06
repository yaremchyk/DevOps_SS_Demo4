

module "aws_ecr" {
   source    = "./ecr"
   namespace = var.namespace
}

module "aws_vpc" {
  source    = "./network/vpc"
  namespace = var.namespace
}
module "aws_backend" {
  source    = "./backend"
  vpc_id              = module.aws_vpc.vpc_id
}

module "aws_subnets" {
  source              = "./network/subnets"
  namespace           = var.namespace
  vpc_id              = module.aws_vpc.vpc_id
  vpc_cidr_block      = "10.0.0.0/16"
  internet_gateway_id = module.aws_vpc.internet_gateway_id
}

module "aws_sg" {
  source          = "./network/sgroups"
  vpc_id          = module.aws_vpc.vpc_id
  namespace       = var.namespace
  public_subnets  = module.aws_subnets.public_subnet_ids
  private_subnets = module.aws_subnets.public_subnet_ids
}

module "aws_alb" {
  source                = "./network/lbalancer"
  namespace             = var.namespace
  vpc_id                = module.aws_vpc.vpc_id
  route53_zone_id       = var.route53_zone_id
  public_subnets        = module.aws_subnets.public_subnet_ids
  security_group_alb_id = module.aws_sg.security_group_alb_id
}


module "aws_iam" {
  source    = "./iam"
  namespace = var.namespace
}



