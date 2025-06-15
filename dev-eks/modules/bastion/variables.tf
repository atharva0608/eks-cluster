variable "subnet_id" {
  description = "Subnet ID where bastion host will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where bastion host will be deployed"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "bastion"
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for bastion host"
  type        = bool
  default     = false
}

variable "associate_elastic_ip" {
  description = "Associate Elastic IP with bastion host"
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}