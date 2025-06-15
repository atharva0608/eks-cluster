# Get current caller identity
data "aws_caller_identity" "current" {}

# Get current user/role details
data "aws_iam_user" "current" {
  count     = var.admin_user != "" ? 1 : 0
  user_name = var.admin_user
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = module.eks.worker_iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      # Add the role that Terraform is using
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-role"
        username = "terraform-admin"
        groups   = ["system:masters"]
      }
    ])

    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${var.account_id}:user/${var.admin_user}"
        username = var.admin_user
        groups   = ["system:masters"]
      },
      # Add current user if different from admin_user
      {
        userarn  = data.aws_caller_identity.current.arn
        username = "current-user"
        groups   = ["system:masters"]
      }
    ])
  }
}

# Create a kubeconfig file
resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name     = var.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_ca_data  = module.eks.cluster_certificate_authority_data
    region          = var.region
  })
  filename = "${path.module}/kubeconfig"
}

# Create RBAC for additional access
resource "kubernetes_cluster_role_binding" "admin_binding" {
  depends_on = [kubernetes_config_map.aws_auth]

  metadata {
    name = "terraform-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = var.admin_user
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = "current-user"
    api_group = "rbac.authorization.k8s.io"
  }
}