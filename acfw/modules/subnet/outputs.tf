output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.main.id
}

output "subnet_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.main.arn
}

output "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  value       = aws_subnet.main.cidr_block
}

output "availability_zone" {
  description = "The Availability Zone of the subnet"
  value       = aws_subnet.main.availability_zone
}
