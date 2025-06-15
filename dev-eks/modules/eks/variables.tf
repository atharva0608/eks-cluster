variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion host security group ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}