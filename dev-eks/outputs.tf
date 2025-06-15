output "bastion_ssh_command" {
  value = "ssh -i ./generated_keys/${var.ssh_key_name}.pem ubuntu@${module.bastion.bastion_public_ip}"
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "worker_node_group_name" {
  value = module.eks.node_group_name
}
output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "cluster_id" {
  value = module.eks.cluster_id
}


output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
