resource "tls_private_key" "eks_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "eks_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.eks_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.eks_key.private_key_pem
  filename        = "${path.module}/generated_keys/${var.ssh_key_name}.pem"
  file_permission = "0400"
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "bastion" {
  source    = "./modules/bastion"
  subnet_id = module.vpc.public_subnet_ids[0]
  vpc_id    = module.vpc.vpc_id
  key_name  = aws_key_pair.eks_key.key_name
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  subnet_ids         = module.vpc.private_subnet_ids
  key_name           = aws_key_pair.eks_key.key_name
  bastion_sg_id      = module.bastion.bastion_sg_id
}
