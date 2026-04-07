variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  description = "a map of subnet ids of VPC on which the cluster will operate"
  type        = map(string)
}

variable "kms_key_arn" {
  description = "etcd secret keys encryption and decryption"
  type        = string
}

variable "public_subnets" {
  description = "A map of public subnet IDs"
  type        = map(string)
}

variable "private_subnets" {
  description = "A map of private subnet IDs"
  type        = map(string)
}
