resource "aws_eks_node_group" "general_purpose_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "general-purpose-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_general_purpose_role.arn

  subnet_ids = values(data.terraform_remote_state.vpc.outputs.private_subnets)

  capacity_type   = "SPOT"
  disk_size       = 20
  instance_types  = ["t4g.medium", "t4g.large"]
  ami_type        = "AL2023_ARM_64_STANDARD"
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_amazon_linux_2023.value)

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  labels = {
    role                             = "frontend"
    "node-role.kubernetes.io/worker" = "frontend"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ecr_readonly,
    aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
    aws_iam_role_policy_attachment.cloudwatch_agent_server_policy
  ]

  tags = {
    Name = "${var.cluster_name}-general-purpose-node"
  }
}

resource "aws_eks_node_group" "cache_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "cache-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_general_purpose_role.arn

  subnet_ids = values(data.terraform_remote_state.vpc.outputs.private_subnets)

  capacity_type   = "ON_DEMAND"
  ami_type        = "AL2023_ARM_64_STANDARD" # "AL2023_x86_64_STANDARD"
  disk_size       = 20
  instance_types  = ["t4g.medium"]
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_amazon_linux_2023.value)

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role                             = "cache"
    "node-role.kubernetes.io/worker" = "cache"
  }

  taint {
    key    = "dedicated"
    value  = "cache"
    effect = "NO_SCHEDULE"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ecr_readonly,
    aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
    aws_iam_role_policy_attachment.cloudwatch_agent_server_policy
  ]

  tags = {
    Name = "${var.cluster_name}-cache-node"
  }
}

resource "aws_eks_node_group" "monitoring_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "monitoring-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_general_purpose_role.arn

  subnet_ids = values(data.terraform_remote_state.vpc.outputs.private_subnets)

  capacity_type   = "ON_DEMAND"
  ami_type        = "AL2023_ARM_64_STANDARD"
  disk_size       = 20
  instance_types  = ["t4g.medium"]
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_amazon_linux_2023.value)

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  labels = {
    role                             = "monitoring"
    "node-role.kubernetes.io/worker" = "monitoring"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ecr_readonly,
    aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
    aws_iam_role_policy_attachment.cloudwatch_agent_server_policy
  ]

  tags = {
    Name = "${var.cluster_name}-monitoring-node"
  }
}

# resource "aws_eks_node_group" "general_purpose_nodes" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "general-purpose-nodes"
#   node_role_arn   = aws_iam_role.eks_node_group_general_purpose_role.arn
#   subnet_ids      = values(var.private_subnets)

#   ami_type       = "AL2023_ARM_64_STANDARD" # "AL2023_x86_64_STANDARD"
#   instance_types = ["t4g.medium"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 1
#   }

#   release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_amazon_linux_2023.value)

#   depends_on = [
#     aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.amazon_eks_cni_policy,
#     aws_iam_role_policy_attachment.amazon_ecr_readonly,
#     aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
#     aws_iam_role_policy_attachment.cloudwatch_agent_server_policy
#   ]
# }

# resource "aws_eks_node_group" "nvidia_gpu_nodes" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "nvidia-gpu-nodes"
#   node_role_arn   = aws_iam_role.eks_node_group_general_purpose_role.arn
#   subnet_ids      = values(var.private_subnets)

#   ami_type       = "AL2023_x86_64_NVIDIA" # "AL2023_ARM_64_NVIDIA"
#   instance_types = ["g6.xlarge"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_nvidia_amazon_linux_2023.value)

#   depends_on = [
#     aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.amazon_eks_cni_policy,
#     aws_iam_role_policy_attachment.amazon_ecr_readonly,
#     aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
#     aws_iam_role_policy_attachment.cloudwatch_agent_server_policy
#   ]
# }
