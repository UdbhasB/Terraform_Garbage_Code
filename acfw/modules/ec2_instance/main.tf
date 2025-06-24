locals {
  # Determine the subnet_id for the instance's primary ENI (device_index 0)
  # This is required by the aws_instance resource.
  instance_primary_subnet_id = coalesce(
    try(one([for eni_config in var.network_interfaces : eni_config.subnet_id if eni_config.device_index == 0]), null),
    var.primary_eni_subnet_id
  )
}

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = local.instance_primary_subnet_id # Ensures subnet_id is appropriately set

  # If network_interfaces are managed by aws_network_interface resources,
  # vpc_security_group_ids on the instance itself should typically be null or empty,
  # as security groups are applied per ENI.
  # This handles the case where no explicit ENIs are defined by var.network_interfaces.
  vpc_security_group_ids = length(var.network_interfaces) == 0 ? var.security_group_ids : null

  # Block device mapping for root volume size
  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3" # General Purpose SSD (gp3)
    delete_on_termination = true
  }

  # User data can be provided if needed
  # user_data = var.user_data

  tags = merge(
    var.tags,
    {
      "Name" = var.instance_name
    }
  )

  # This is tricky: aws_instance can define its primary network interface implicitly
  # OR you can define all network interfaces explicitly using aws_network_interface and attach them.
  # The prompt implies specific IPs for multiple ENIs (private and management).
  # Thus, we should use explicit aws_network_interface resources.
  # The aws_instance's subnet_id is only for the primary ENI if not explicitly defined.
  # If we define aws_network_interface for device_index 0, this subnet_id is ignored.

  # To handle this, this module will primarily create the instance
  # and then create and attach aws_network_interface resources based on the var.network_interfaces list.
  # If var.network_interfaces is empty, it falls back to creating a simple instance with one ENI.

  # If network_interfaces are defined, the primary ENI (device_index 0) should be among them.
  # The `subnet_id` at the instance level is problematic if we are defining all ENIs separately.
  # Let's assume if `var.network_interfaces` is provided, it defines ALL interfaces.
  # If `var.network_interfaces` is NOT provided, then `primary_eni_subnet_id` and `security_group_ids` are used for a single ENI.

  lifecycle {
    ignore_changes = [
      # If ENIs are managed separately, ignore changes to these instance-level attributes
      # subnet_id, # This might be needed if we conditionally set it.
      # vpc_security_group_ids # Also conditional.
    ]
  }
}

resource "aws_network_interface" "custom_eni" {
  for_each = { for idx, eni_config in var.network_interfaces : idx => eni_config }

  subnet_id       = each.value.subnet_id
  private_ips     = each.value.private_ip != null ? [each.value.private_ip] : null
  security_groups = each.value.security_group_ids
  description     = each.value.description
  
  attachment {
    instance     = aws_instance.main.id
    device_index = each.value.device_index
  }

  tags = merge(
    var.tags,
    {
      "Name" = each.value.description # Using ENI description as Name tag for the ENI itself
    }
  )
}

# Output the primary private IP. If multiple ENIs, this logic might need refinement
# to select the "main" private IP as per user expectation.
# For now, outputting the instance's primary_private_ip attribute.
# If ENIs are explicitly defined, the instance's primary_network_interface_id refers to the one with device_index 0.
# aws_instance.main.primary_private_ip should reflect the private IP of the ENI at device_index 0.
# If no explicit ENIs, it's the IP of the implicit ENI.
# If explicit ENIs, aws_instance.main.private_ip is the private IP of the attachment at device_index = 0.
# So this should be correct.
# The mgmt_ip is one of these private_ips on a specific ENI.
# The output "private_ip" for the module will be the primary IP of the instance.
# Other IPs are accessible via the network_interface outputs if needed.

  # Removed invalid top-level lifecycle block. Consider using 'precondition' inside a resource or as a custom validation in variables if needed.
