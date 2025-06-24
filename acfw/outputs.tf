output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "jump_server_public_ip" {
  description = "Public IP address of the Jump Server"
  value       = module.jump_server_eip.public_ip
  depends_on  = [module.jump_server_eip]
}

output "jump_server_private_ip" {
  description = "Private IP address of the Jump Server"
  value       = module.jump_server.private_ip
  depends_on  = [module.jump_server]
}

output "public_access_security_group_id" {
  description = "The ID of the public access security group"
  value       = module.public_access_sg.security_group_id
}

output "management_subnet_id" {
  description = "The ID of the management subnet"
  value       = module.management_subnet.subnet_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.igw.internet_gateway_id
}

# Add more outputs as needed, for example, for each vendor's resources
# This can get verbose, so consider what's most important.
# Example for one vendor's VM private IPs (can be adapted to a loop in outputs if complex)
# output "axgate_vm_private_ips" {
#   description = "Private IPs of AXGATE VMs"
#   value = {
#     for k, vm in module.axgate_vms : k => vm.private_ip
#   }
# }
