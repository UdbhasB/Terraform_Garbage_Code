resource "aws_eip" "main" {
  # Conditional association: only set instance or network_interface_id if provided.
  # If both are null, it's an unassociated EIP.
  # For this project, we primarily associate with network_interface_id.

  instance             = var.instance_id # Typically for EC2-Classic or if associating directly with instance
  network_interface    = var.network_interface_id
  # associate_with_private_ip = var.private_ip_to_associate # If EIP should be associated with a specific private IP on an ENI

  vpc = true # Indicates the EIP is for use with instances in a VPC. Always true for modern usage.

  tags = merge(
    var.tags,
    {
      "Name" = var.eip_name
    }
  )
}

# Note: The aws_eip resource itself handles association if network_interface_id or instance_id is provided.
# The aws_eip_association resource is an alternative way to manage association,
# particularly useful if the EIP and the target (instance/ENI) are managed in different configurations
# or if you need to change association without recreating the EIP.
# For this module, direct association in aws_eip is simpler if the target ID is known at creation time.
# If we need to associate an *existing* EIP (by importing it or referencing its allocation_id),
# then aws_eip_association would be more appropriate.
# Given the prompt, we are creating a new EIP and associating it.

# The root main.tf calls this module for the jump server:
# module "jump_server_eip" {
#   source = "./modules/elastic_ip"
#   network_interface_id = module.jump_server.network_interface_ids[0] # This is correct
#   eip_name             = "${local.naming_prefix}-JUMP-SERVER-ELASTIC-IP"
#   tags = merge(local.common_tags, {
#     "Name" = "${local.naming_prefix}-JUMP-SERVER-ELASTIC-IP"
#   })
#   depends_on = [module.jump_server]
# }
# This structure is fine. The `network_interface_id` will be passed to `var.network_interface_id`.
# The `depends_on` in the root module call ensures the ENI exists before EIP tries to associate.
