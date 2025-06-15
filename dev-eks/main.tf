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

  depends_on = [tls_private_key.eks_key]
}

# Create the generated_keys directory
resource "null_resource" "create_keys_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/generated_keys"
  }

  triggers = {
    always_run = timestamp()
  }
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  name_prefix     = var.cluster_name
  cluster_name    = var.cluster_name
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  additional_tags = local.common_tags
}

module "bastion" {
  source              = "./modules/bastion"
  subnet_id           = module.vpc.public_subnet_ids[0]
  vpc_id              = module.vpc.vpc_id
  key_name            = aws_key_pair.eks_key.key_name
  name_prefix         = var.cluster_name
  instance_type       = var.bastion_instance_type
  allowed_cidr_blocks = var.allowed_cidr_blocks
  vpc_cidr            = var.vpc_cidr
  region              = var.region
  enable_monitoring   = var.enable_bastion_monitoring
  additional_tags     = local.common_tags
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = module.vpc.private_subnet_ids
  key_name      = aws_key_pair.eks_key.key_name
  vpc_id        = module.vpc.vpc_id
  bastion_sg_id = module.bastion.bastion_sg_id
  cluster_version = var.cluster_version
  node_instance_type = var.node_instance_type
  node_desired_size = var.node_desired_size
  node_max_size = var.node_max_size
  node_min_size = var.node_min_size
  enable_cluster_logs = var.enable_cluster_logs
  cluster_log_types = var.cluster_log_types
  additional_tags = local.common_tags
}

# Local values for common tags
locals {
  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project
      Owner       = var.owner
      ManagedBy   = "terraform"
    },
    var.additional_tags
  )
}