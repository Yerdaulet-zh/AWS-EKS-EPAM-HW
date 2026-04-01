resource "aws_iam_role" "eks_node_group_general_purpose_role" {
  name = "eks-node-group-general-purpose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Allow nodes to connect to the EKS cluster
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_general_purpose_role.name
}

# Allow the VPC CNI plugin to manage network interfaces (ENIs)
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_general_purpose_role.name
}

# Allow nodes to pull images from your private ECR repositories
resource "aws_iam_role_policy_attachment" "amazon_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_general_purpose_role.name
}

# Allow SSM Session Manager to work (no SSH keys needed)
resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_group_general_purpose_role.name
}

# Allow nodes to send logs to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_node_group_general_purpose_role.name
}

# If Pods do not use the pod identity for secrets access
# resource "aws_iam_role_policy_attachment" "secrets_manager_read" {
#   policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
#   role       = aws_iam_role.eks_node_group_general_purpose_role.name
# }
