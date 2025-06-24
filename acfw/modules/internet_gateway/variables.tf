variable "vpc_id" {
  description = "The ID of the VPC to attach the Internet Gateway to."
  type        = string
}

variable "igw_name" {
  description = "The name tag for the Internet Gateway."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Internet Gateway."
  type        = map(string)
  default     = {}
}
