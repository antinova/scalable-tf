output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.item.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.item.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.item.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the VPC's default security group"
  value       = aws_default_security_group.item.id
}

output "public_subnets" {
  description = "Public subnets: List of IDs"
  value       = flatten([for item in aws_subnet.public : [item.id]])
}

output "public_subnet_arns" {
  description = "Public subnets: List of ARNs"
  value       = flatten([for item in aws_subnet.public : [item.arn]])
}

output "public_subnets_cidr_blocks" {
  description = "Publics subnets: List of CIDR blocks"
  value       = flatten([for item in aws_subnet.public : [item.cidr_block]])
}

output "private_subnets" {
  description = "Private subnets: List of IDs"
  value       = flatten([for item in aws_subnet.private : [item.id]])
}

output "private_subnet_arns" {
  description = "Private subnets: List of ARNs"
  value       = flatten([for item in aws_subnet.private : [item.arn]])
}

output "private_subnets_cidr_blocks" {
  description = "Private subnets: List of CIDR blocks"
  value       = flatten([for item in aws_subnet.private : [item.cidr_block]])
}
