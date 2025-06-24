resource "aws_subnet" "main" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  map_public_ip_on_launch = var.map_public_ip_on_launch # Useful for public subnets, like management

  tags = merge(
    var.tags,
    {
      "Name" = var.subnet_name
    }
  )
}
