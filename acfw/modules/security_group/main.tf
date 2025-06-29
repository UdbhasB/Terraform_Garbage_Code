resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids = lookup(ingress.value, "prefix_list_ids", null)
      security_groups = lookup(ingress.value, "security_groups", null) # For SG to SG communication
      self = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = lookup(egress.value, "description", null)
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids = lookup(egress.value, "prefix_list_ids", null)
      security_groups = lookup(egress.value, "security_groups", null)
      self = lookup(egress.value, "self", null)
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.sg_name
    }
  )
}
