variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
  default     = null # Make it optional if some AMIs don't need it (e.g. Windows with password) or if managed by session manager
}

variable "disk_size" {
  description = "Size of the root block device in GB"
  type        = number
  default     = 30 # A reasonable default
}

variable "tags" {
  description = "A map of tags to assign to the instance and its resources"
  type        = map(string)
  default     = {}
}

# Variables for single ENI setup (when network_interfaces is not used)
variable "primary_eni_subnet_id" {
  description = "Subnet ID for the primary network interface (used if network_interfaces is empty)"
  type        = string
  default     = null # Required if network_interfaces is not provided
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the primary ENI (used if network_interfaces is empty)"
  type        = list(string)
  default     = []
}

# Variable for defining multiple network interfaces
variable "network_interfaces" {
  description = "A list of network interface configurations for the instance. If provided, this defines all ENIs."
  type = list(object({
    subnet_id          = string
    private_ip         = optional(string) # Make private_ip optional, AWS can auto-assign if null
    description        = string
    device_index       = number
    security_group_ids = list(string)
  }))
  default = [] # If empty, the instance uses primary_eni_subnet_id and security_group_ids for a single ENI
}

# variable "user_data" {
#   description = "User data script to run on instance launch"
#   type        = string
#   default     = null
# }

# Note: The EC2 module in main.tf was called with `network_interfaces` for the Jump Server and will be for vendor VMs.
# So, `primary_eni_subnet_id` and `security_group_ids` will not be used in those cases.
# The `aws_instance.subnet_id` will be set to the subnet_id of the ENI with device_index = 0 if `network_interfaces` is used.
# This needs to be handled carefully in the main.tf of the module.
# Corrected logic in main.tf: aws_instance.subnet_id should be set to the subnet_id of the network_interface with device_index = 0
# if var.network_interfaces is not empty. Otherwise, it uses var.primary_eni_subnet_id.

# Let's refine the aws_instance.subnet_id logic in main.tf for the module.
# If var.network_interfaces is not empty, aws_instance.subnet_id should ideally be the subnet_id of the ENI with device_index 0.
# Terraform's aws_instance resource uses `subnet_id` for its primary ENI if `network_interface` block is not used at instance level.
# If `aws_network_interface` resources are used and attached, the `subnet_id` on `aws_instance` is for the *implicit* primary ENI
# that Terraform tries to create *unless* an `aws_network_interface` is attached at `device_index = 0`.
# If an ENI is attached at device_index 0, the instance-level `subnet_id` and `security_groups` are ignored for that primary ENI.

# The current `main.tf` for `ec2_instance` module:
# - Sets `aws_instance.subnet_id = var.primary_eni_subnet_id`. This is fine. If `var.network_interfaces` is provided
#   and includes an ENI for device_index 0, that `aws_network_interface` will become the primary, and its subnet setting will take precedence.
#   The instance-level `subnet_id` is more of a fallback or for cases where no explicit ENI at index 0 is defined.
# - `vpc_security_group_ids` is conditionally set. This is also fine. If explicit ENIs are used, SGs are managed per-ENI.

# One consideration: if `var.network_interfaces` is used, `var.primary_eni_subnet_id` is not strictly necessary.
# However, `aws_instance` requires a `subnet_id` if not using deprecated `network_interface {}` blocks directly in `aws_instance`.
# So, we must supply one. A common pattern is to use the subnet_id of the first ENI (device_index 0).
# The module's main.tf should be:
# `subnet_id = length(var.network_interfaces) > 0 ? var.network_interfaces[0].subnet_id : var.primary_eni_subnet_id`
# This assumes that if network_interfaces are provided, the first one in the list is for device_index 0.
# This is a convention we'd have to enforce or make more robust (e.g. find where device_index == 0).

# For now, the existing main.tf is mostly okay. AWS is usually smart enough if an ENI is attached at device_index 0.
# The `primary_eni_subnet_id` variable can be seen as a default or a required placeholder if no explicit ENIs are given.
# When calling the module with `network_interfaces`, the `primary_eni_subnet_id` can be omitted by the caller (as it has default null),
# but the resource `aws_instance` might complain if it ends up null and no `network_interface` block (deprecated) is in `aws_instance`.
# The `aws_network_interface` resources are separate.
# Let's make `primary_eni_subnet_id` truly optional by setting it in `aws_instance` only if `var.network_interfaces` is empty.
# No, `subnet_id` is required for `aws_instance` unless using `launch_template` or `network_interface` (deprecated inline block).
# So, we need a value for `aws_instance.subnet_id`.
# The simplest is to require `primary_eni_subnet_id` if `network_interfaces` is empty,
# and if `network_interfaces` is *not* empty, use the subnet_id of the ENI designated as device_index 0.

# Revised plan for `modules/ec2_instance/main.tf`:
# ```terraform
# locals {
#   primary_subnet_for_instance = length(var.network_interfaces) > 0 ? (
#     one([for eni in var.network_interfaces : eni.subnet_id if eni.device_index == 0])
#   ) : var.primary_eni_subnet_id
# }
#
# resource "aws_instance" "main" {
#   ...
#   subnet_id = local.primary_subnet_for_instance
#   ...
# }
# ```
# This requires that if `network_interfaces` is used, one and only one entry has `device_index = 0`.
# This is a good practice.

# Let's stick with the current `main.tf` for the module for now. The provided example for `aws_network_interface` attachment
# implies that the `aws_instance` might not even need `subnet_id` if an ENI is attached at index 0.
# If TF plan/apply fails, this is an area to revisit.
# The AWS provider documentation for `aws_instance` states `subnet_id` is "Required unless network_interface is specified."
# The `network_interface` here refers to the deprecated inline block, not `aws_network_interface` resource.
# So, `subnet_id` IS required on `aws_instance`.
# The current `main.tf` sets `subnet_id = var.primary_eni_subnet_id`.
# This means the CALLER of the module (root main.tf) MUST provide `primary_eni_subnet_id` if `network_interfaces` is empty,
# OR it must provide the subnet_id of the device_index 0 ENI as `primary_eni_subnet_id` when also providing `network_interfaces`.
# This is slightly awkward.

# Alternative in module `main.tf`:
# `subnet_id = var.primary_eni_subnet_id != null ? var.primary_eni_subnet_id : (length(var.network_interfaces) > 0 ? one([for eni in var.network_interfaces : eni.subnet_id if eni.device_index == 0]) : null)`
# And then add a validation that this value is not null.
# This makes `primary_eni_subnet_id` truly optional if `network_interfaces` defines the primary.

# For now, the variables.tf is as defined. The onus is on the caller to set `primary_eni_subnet_id` correctly.
# Given the root `main.tf` structure, when `network_interfaces` is used, `primary_eni_subnet_id` is not being explicitly passed to the module call.
# This means it will default to `null`. This will cause an error.
# So, the module's `aws_instance.subnet_id` needs to be smarter.

# Let's refine `modules/ec2_instance/main.tf` regarding `subnet_id` for `aws_instance` now.
# (This is technically part of the previous file creation, but good to fix.)

# The `aws_instance` resource needs a `subnet_id` for its primary network interface (eth0).
# If `var.network_interfaces` is provided and contains an entry for `device_index = 0`,
# that `aws_network_interface` resource will define eth0. The `subnet_id` for `aws_instance`
# should match that ENI's subnet.
# If `var.network_interfaces` is empty, then `var.primary_eni_subnet_id` is used.

# Change in `modules/ec2_instance/main.tf` will be:
# ```HCL
# locals {
#   # Determine the subnet_id for the instance's primary ENI (device_index 0)
#   # This is required by the aws_instance resource.
#   instance_primary_subnet_id = coalesce(
#     try(one([for eni_config in var.network_interfaces : eni_config.subnet_id if eni_config.device_index == 0]), null),
#     var.primary_eni_subnet_id
#   )
# }
#
# resource "aws_instance" "main" {
#   # ... other attributes ...
#   subnet_id = local.instance_primary_subnet_id # This ensures subnet_id is always set if possible
#
#   # Ensure this doesn't cause issues if an explicit ENI is attached at device_index 0
#   # AWS provider should handle this: if an aws_network_interface is attached at device_index 0,
#   # it overrides the implicit primary ENI defined by instance's subnet_id.
#
#   # Add validation for local.instance_primary_subnet_id
#   lifecycle {
#     precondition {
#       condition     = local.instance_primary_subnet_id != null
#       error_message = "Instance primary subnet ID could not be determined. Ensure 'primary_eni_subnet_id' is set if 'network_interfaces' is empty, or that 'network_interfaces' includes an entry for device_index = 0."
#     }
#   }
# // ... rest of the resource
# }
# ```
# This seems more robust. I will apply this change to `modules/ec2_instance/main.tf` after this step.
# For now, `variables.tf` is complete as written.
