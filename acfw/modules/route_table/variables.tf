variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "route_table_name" {
  description = "The name tag for the Route Table."
  type        = string
}

variable "routes" {
  description = "A list of route objects to create in the route table."
  type = list(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    
    gateway_id                 = optional(string) # IGW, VGW
    nat_gateway_id             = optional(string) # NAT Gateway
    instance_id                = optional(string) # NAT Instance
    network_interface_id       = optional(string) # ENI
    transit_gateway_id         = optional(string) # TGW
    vpc_peering_connection_id  = optional(string) # VPC Peering
    vpc_endpoint_id            = optional(string) # Gateway VPC Endpoint
    # core_network_arn           = optional(string) # AWS Cloud WAN
  }))
  default = []
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with this route table. Can be empty if not associating with subnets directly (e.g. main route table)."
  type        = list(string)
  default     = []
}

variable "associate_with_gateway_id" {
  description = "An Internet Gateway or Virtual Private Gateway ID to associate with this route table (e.g. for a main route table scenario, though explicit subnet association is more common)."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the Route Table."
  type        = map(string)
  default     = {}
}

# Note on usage from root main.tf:
# For the public management route table:
# module "management_route_table" {
#   source = "./modules/route_table"
#   vpc_id = module.vpc.vpc_id
#   subnet_ids = [module.management_subnet.subnet_id] # Corrected from subnet_id to subnet_ids
#   routes = [{
#     cidr_block = "0.0.0.0/0"
#     gateway_id = module.igw.internet_gateway_id
#   }]
#   route_table_name = "${local.naming_prefix}-MANAGEMENT-PUBLIC-RT"
#   tags = local.common_tags
# }
#
# For private route tables (per vendor private subnet):
# module "vendor_private_rt" {
#   source = "./modules/route_table"
#   vpc_id = var.vpc_id
#   subnet_ids = [module.private_subnet.subnet_id] # This will be created inside vendor_setup module
#   routes = [] # No default route to IGW. Only local VPC routes are implicit.
#               # Add routes here if needed (e.g. to NAT Gateway, TGW, etc.)
#   route_table_name = "..."
#   tags = "..."
# }
# The root main.tf needs a slight adjustment for the `subnet_id` to `subnet_ids` parameter for the management_route_table call.
# The `associate_with_gateway_id` is typically for making a route table the "main" route table by associating it with a VGW or IGW.
# However, associating with subnets is the more common use case for custom route tables.
# The main VPC route table is implicitly created with the VPC. This module is for creating *additional* custom route tables.
