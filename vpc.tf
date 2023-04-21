# Creating VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block			= var.eks_vpc_cidr
  enable_dns_hostnames 	= true
  tags = {
    Name = "EKS VPC"
  }
}

# Creating Public Subnet
resource "aws_subnet" "eks_vpc_public_subnet" {
  vpc_id     		= aws_vpc.eks_vpc.id
  cidr_block 		= var.eks_vpc_subnet_pub_cidr
  availability_zone = var.eks_vpc_subnet_pub_az
  tags = {
    Name = "EKS VPC Public Subnet"
  }
}

# Creating Private Subnet 1
resource "aws_subnet" "eks_vpc_private_subnet_1" {
  vpc_id     		= aws_vpc.eks_vpc.id
  cidr_block 		= var.eks_vpc_subnet_priv_cidr_1
  availability_zone = var.eks_vpc_subnet_priv_az_1
  tags = {
    Name = "EKS VPC Private Subnet"
  }
}

# Creating Private Subnet 2
resource "aws_subnet" "eks_vpc_private_subnet_2" {
  vpc_id        = aws_vpc.eks_vpc.id
  cidr_block    = var.eks_vpc_subnet_priv_cidr_2
  availability_zone = var.eks_vpc_subnet_priv_az_2
  tags = {
    Name = "EKS VPC Private Subnet"
  }
}

# Creating IGW for Public Subnet
resource "aws_internet_gateway" "eks_vpc_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "EKS VPC IGW"
  }
}

# Creating EIP for NAT
resource "aws_eip" "eks_vpc_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.eks_vpc_igw]
}

# Creating NAT
resource "aws_nat_gateway" "eks_vpc_nat_gw" {
  allocation_id = aws_eip.eks_vpc_nat_eip.id
  subnet_id     = aws_subnet.eks_vpc_public_subnet.id
  tags = {
    Name = "EKS VPC NAT"
  }
}

# Creating Route table for Public Subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.eks_vpc_igw.id
  }
  tags = {
      Name = "EKS VPC Public Subnet Route Table"
  }
}

# Creating Route table for Private Subnet
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.eks_vpc_nat_gw.id
  }
  tags = {
      Name = "EKS VPC Private Subnet Route Table"
  }
}

# Route table associations for Public Subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id = aws_subnet.eks_vpc_public_subnet.id
  route_table_id = aws_route_table.PublicRT.id
}

# Route table associations for Private Subnet 1
resource "aws_route_table_association" "PrivateRTassociation1" {
  subnet_id = aws_subnet.eks_vpc_private_subnet_1.id
  route_table_id = aws_route_table.PrivateRT.id
}

# Route table associations for Private Subnet 2
resource "aws_route_table_association" "PrivateRTassociation2" {
  subnet_id = aws_subnet.eks_vpc_private_subnet_2.id
  route_table_id = aws_route_table.PrivateRT.id
}

# Default Security Group
resource "aws_default_security_group" "security_group_default" {
  vpc_id = aws_vpc.eks_vpc.id
  depends_on  = [
    aws_vpc.eks_vpc
  ]
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EKS VPC Default SG"
  }
}