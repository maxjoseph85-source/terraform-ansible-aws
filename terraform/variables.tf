variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Machine Image ID for EC2"
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"  # Free tier eligible
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "terraform-key"
}