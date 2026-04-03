resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.34"

  deletion_protection           = false
  bootstrap_self_managed_addons = false
  enabled_cluster_log_types     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  force_update_version          = false

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  control_plane_scaling_config {
    # ["standard" "tier-xl" "tier-2xl" "tier-4xl" "tier-8xl"]
    tier = "standard"
  }

  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
    ip_family         = "ipv4"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = values(var.subnet_ids)
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}
