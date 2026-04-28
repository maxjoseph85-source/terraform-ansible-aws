terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC - Your private network on AWS
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

# Subnet - A subdivision of your VPC
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "terraform-subnet"
  }
}

# Internet Gateway - Allows your VPC to reach the internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "terraform-igw"
  }
}

# Route Table - Directs traffic from subnet to the internet
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "terraform-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main_rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

# Security Group - Firewall rules for your EC2 instance
resource "aws_security_group" "main_sg" {
  name        = "terraform-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}

# EC2 Instance - Your virtual server
resource "aws_instance" "main_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "terraform-ec2"
  }
}

# S3 Bucket - Cloud storage
resource "aws_s3_bucket" "main_bucket" {
  bucket = "terraform-ansible-project-${random_id.bucket_id.hex}"
  tags = {
    Name = "terraform-s3"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}