# AWS Configuration
region         = "us-west-2"
profile        = "default"
account_id     = "337909764010"

# VPC Configuration
vpc_cidr       = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs            = ["us-west-2a", "us-west-2b"]

# EKS Configuration
cluster_name   = "devv-cluster"
cluster_version = "1.28"
node_instance_type = "t3.medium"
node_desired_size = 2
node_max_size = 3
node_min_size = 1

# SSH Key Configuration
ssh_key_name   = "eks-dev-key"

# IAM Configuration
admin_user     = "terraform-admin"

# Bastion Configuration
bastion_instance_type = "t3.micro"
enable_bastion_monitoring = true

# Tags
environment    = "dev"
project        = "eks-cluster"
owner          = "devops-team"

# Security Configuration  
allowed_cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
enable_cluster_logs = true
cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

# Networking
enable_nat_gateway = true
single_nat_gateway = true  # Set to false for HA in production
enable_vpn_gateway = false
enable_dns_hostnames = true
enable_dns_support = true