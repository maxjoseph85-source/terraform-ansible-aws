output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main_ec2.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main_bucket.bucket
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
}