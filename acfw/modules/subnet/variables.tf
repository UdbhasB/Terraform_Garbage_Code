variable "vpc_id" {
  description = "The ID of the VPC to create the subnet in"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The Availability Zone for the subnet"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
  type        = bool
  default     = false # Typically false for private subnets, true for public ones
}

variable "tags" {
  description = "A map of tags to assign to the subnet"
  type        = map(string)
  default     = {}
}
