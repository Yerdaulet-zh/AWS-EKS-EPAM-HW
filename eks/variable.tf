variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster (deprecated - sourced from vpc remote state)"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "etcd secret keys encryption and decryption"
  type        = string
}

variable "subnet_ids" {
  description = "a map of subnet ids of VPC on which the cluster will operate (deprecated - sourced from vpc remote state)"
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "A map of public subnet IDs (deprecated - sourced from vpc remote state)"
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  description = "A map of private subnet IDs (deprecated - sourced from vpc remote state)"
  type        = map(string)
  default     = {}
}
