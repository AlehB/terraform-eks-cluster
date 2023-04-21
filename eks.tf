# Creating an IAM Role for the AWS EKS Cluster. Attaching 'AmazonEKSClusterPolicy' policy

resource "aws_iam_role" "eks_iam_role" {
  name = "eks-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
  tags = {
    "Terraform" = "true"
  }
}
resource "aws_iam_role_policy_attachment" "eks_iam_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam_role.name
}

# Creating an IAM Role for the Node Group. Attaching 'AmazonEKSWorkerNodePolicy', 'AmazonEKS_CNI_Policy', 'AmazonEC2ContainerRegistryReadOnly' policies

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = {
    Terraform = "true"
  }
}
resource "aws_iam_role_policy_attachment" "worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}
resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}
resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Creating an EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  depends_on = [ aws_iam_role_policy_attachment.eks_iam_policy_attachment ]
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_iam_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_vpc_public_subnet.id, aws_subnet.eks_vpc_private_subnet_1.id, aws_subnet.eks_vpc_private_subnet_2.id]
  }
  tags = {
      Name = var.eks_cluster_name
    }
}

# Creating Private EKS Node Group

resource "aws_eks_node_group" "eks_private_node_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.eks_cluster_name}-private-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.eks_vpc_private_subnet_1.id, aws_subnet.eks_vpc_private_subnet_2.id]
  instance_types  = ["${var.eks_nodes_instance_type}"]
  disk_size       = 8

  scaling_config {
    desired_size = var.eks_scaling_config_des
    max_size     = var.eks_scaling_config_max
    min_size     = var.eks_scaling_config_min
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
      Name = var.eks_cluster_name
    }

  # Ensure that Cluster and IAM Role permissions are created
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.worker_node_policy_attachment,
    aws_iam_role_policy_attachment.cni_policy_attachment,
    aws_iam_role_policy_attachment.ecr_readonly_policy_attachment,
  ]
}