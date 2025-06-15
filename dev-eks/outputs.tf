output "bastion_ssh_command" {
  description = "SSH command to connect to bastion host"
  value       = "ssh -i ./generated_keys/${var.ssh_key_name}.pem ubuntu@${module.bastion.bastion_public_ip}"
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "worker_node_group_name" {
  description = "EKS worker node group name"
  value       = module.eks.node_group_name
}

output "worker_iam_role_arn" {
  description = "IAM role ARN of the EKS worker nodes"
  value       = module.eks.worker_iam_role_arn
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "kubectl_config_command" {
  description = "Command to update kubectl config"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name} --profile ${var.profile}"
}

output "kubeconfig_path" {
  description = "Path to generated kubeconfig file"
  value       = "${path.module}/kubeconfig"
}