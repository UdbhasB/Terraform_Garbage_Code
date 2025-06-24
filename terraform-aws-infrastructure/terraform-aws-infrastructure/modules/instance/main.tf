resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  private_ip    = var.private_ip

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}


