output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "node_group_name" {
  value = aws_eks_node_group.node_group.node_group_name
}
output "worker_iam_role_arn" {
  value = aws_iam_role.eks_node.arn
}
output "cluster_id" {
  value = aws_eks_cluster.this.name
}


output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
