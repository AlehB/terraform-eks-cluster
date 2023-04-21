variable "aws_region" {
  default     = "us-east-1"
  description = "AWS Region to deploy EKS VPC"
}

variable "eks_vpc_cidr" {
  default     = "10.10.0.0/16"
  description = "EKS VPC CIDR range"
}

variable "eks_vpc_subnet_pub_cidr" {
  default     = "10.10.0.0/24"
  description = "EKS VPC Public Subnet CIDR range"
}

variable "eks_vpc_subnet_pub_az" {
  default     = "us-east-1a"
  description = "EKS VPC Public Subnet Availability zone"
}

variable "eks_vpc_subnet_priv_cidr_1" {
  default     = "10.10.1.0/24"
  description = "EKS VPC Private Subnet 1 CIDR range"
}

variable "eks_vpc_subnet_priv_az_1" {
  default     = "us-east-1a"
  description = "EKS VPC Private Subnet 1 Availability zone"
}

variable "eks_vpc_subnet_priv_cidr_2" {
  default     = "10.10.2.0/24"
  description = "EKS VPC Private Subnet 2 CIDR range"
}

variable "eks_vpc_subnet_priv_az_2" {
  default     = "us-east-1b"
  description = "EKS VPC Private Subnet 2 Availability zone"
}

variable "eks_cluster_name" {
  default     = "eks-test"
  description = "Name of the EKS Cluster"
}

variable "eks_nodes_instance_type" {
  default     = "t2.small"
  description = "EKS Node Group Instance Type"
}

variable "eks_nodes_disk_size" {
  default     = "8"
  description = "EKS Node Group Disk Size"
}

variable "eks_scaling_config_des" {
  default     = "2"
  description = "EKS Node Group Desired Size"
}

variable "eks_scaling_config_max" {
  default     = "2"
  description = "EKS Node Group Maximum Size"
}

variable "eks_scaling_config_min" {
  default     = "1"
  description = "EKS Node Group Minimum Size"
}
