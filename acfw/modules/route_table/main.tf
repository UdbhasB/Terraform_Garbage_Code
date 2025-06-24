resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block                = lookup(route.value, "cidr_block", null)
      ipv6_cidr_block           = lookup(route.value, "ipv6_cidr_block", null)
      destination_prefix_list_id= lookup(route.value, "destination_prefix_list_id", null)
      
      gateway_id                = lookup(route.value, "gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null) # For routing to an instance (e.g. NAT instance)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null) # For Gateway Endpoints (S3, DynamoDB)
      # core_network_arn          = lookup(route.value, "core_network_arn", null) # If using AWS Cloud WAN
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.route_table_name
    }
  )
}

resource "aws_route_table_association" "main" {
  # Conditionally create associations if subnet_ids are provided
  count = length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.main.id
}

# Association for internet gateway or virtual private gateway
resource "aws_route_table_association" "gateway_association" {
  # Conditionally create if gateway_id is provided for association (less common for IGW, mainly for VGW)
  count = var.associate_with_gateway_id != null ? 1 : 0

  gateway_id     = var.associate_with_gateway_id
  route_table_id = aws_route_table.main.id
}
