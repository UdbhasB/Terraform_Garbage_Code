output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "default_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.main.main_route_table_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL for this VPC"
  value       = aws_vpc.main.default_network_acl_id
}

output "default_security_group_id" {
  description = "The ID of the default security group for this VPC"
  value       = aws_vpc.main.default_security_group_id
}
