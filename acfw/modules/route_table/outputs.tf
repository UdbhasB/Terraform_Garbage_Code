output "route_table_id" {
  description = "The ID of the Route Table."
  value       = aws_route_table.main.id
}

output "route_table_arn" {
  description = "The ARN of the Route Table."
  value       = aws_route_table.main.arn
}

output "route_table_owner_id" {
  description = "The ID of the AWS account that owns the route table."
  value       = aws_route_table.main.owner_id
}

output "associated_subnet_ids" {
  description = "List of subnet IDs associated with this route table by this module."
  # This will collect all subnet_ids from the aws_route_table_association resources
  value       = [for assoc in aws_route_table_association.main : assoc.subnet_id]
}
