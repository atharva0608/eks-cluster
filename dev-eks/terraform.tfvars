region         = "us-west-2"
profile        = "default"

vpc_cidr       = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs            = ["us-west-2a", "us-west-2b"]

cluster_name   = "devv-cluster"
ssh_key_name   = "eks-dev-key"
admin_user = "terraform-admin"
account_id = "337909764010"
