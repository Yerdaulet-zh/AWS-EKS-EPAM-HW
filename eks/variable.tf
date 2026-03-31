variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  description = "a list of subent ids of VPC on which the cluster will operate"
  type        = map(string)
}
