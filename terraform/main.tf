

module "aws_ecr" {
   source    = "./modules/ecr"
   namespace = var.namespace
}

module "aws_vpc" {
  source    = "./modules/network/vpc"
  namespace = var.namespace
}
module "aws_backend" {
  source    = "./modules/backend"
  vpc_id              = module.aws_vpc.vpc_id
}

module "aws_subnets" {
  source              = "./modules/network/subnets"
  namespace           = var.namespace
  vpc_id              = module.aws_vpc.vpc_id
  vpc_cidr_block      = "10.0.0.0/16"
  internet_gateway_id = module.aws_vpc.internet_gateway_id
}

module "aws_sg" {
  source          = "./modules/network/sgroups"
  vpc_id          = module.aws_vpc.vpc_id
  namespace       = var.namespace
  public_subnets  = module.aws_subnets.public_subnet_ids
  private_subnets = module.aws_subnets.public_subnet_ids
}

module "aws_alb" {
  source                = "./modules/network/lbalancer"
  namespace             = var.namespace
  vpc_id                = module.aws_vpc.vpc_id
  route53_zone_id       = var.route53_zone_id
  public_subnets        = module.aws_subnets.public_subnet_ids
  security_group_alb_id = module.aws_sg.security_group_alb_id
}


module "aws_iam" {
  source    = "./modules/iam"
  namespace = var.namespace
}

module "eks" {
  count              = 1
  source             = "./modules/eks"
  vpc                = module.network.vpc_id
  public_subnet_ids  = module.eks.public-us-east-1a.id
  private_subnet_ids = module.eks.private-us-east-1a.id
}



