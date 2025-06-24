output "eip_id" {
  description = "Allocation ID of the Elastic IP." # Also known as Allocation ID
  value       = aws_eip.main.id
}

output "public_ip" {
  description = "Public IP address of the Elastic IP."
  value       = aws_eip.main.public_ip
}

output "private_ip" {
  description = "Private IP address associated with the Elastic IP (if applicable, depends on association)."
  value       = aws_eip.main.private_ip
}

output "association_id" {
  description = "Association ID of the Elastic IP (if associated)."
  value       = aws_eip.main.association_id
}

output "network_interface_id" {
  description = "ID of the network interface this EIP is associated with (if any)."
  value       = aws_eip.main.network_interface
}

output "instance_id" {
  description = "ID of the instance this EIP is associated with (if any)."
  value       = aws_eip.main.instance
}
