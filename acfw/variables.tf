variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Availability zones to use for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # Default to two AZs
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
  # User will provide this, so no default.
  # Add a placeholder or leave it for the user to fill in if needed.
  # default     = "your-ssh-key-name"
}

variable "windows_ami_id" {
  description = "AMI ID for Windows instances"
  type        = string
  # This will vary by region, provide a common one or make it a required input
  # Example for us-east-1, Windows Server 2019 Base
  default = "ami-0c7217cdde317f31f"
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu instances"
  type        = string
  # Example for us-east-1, Ubuntu Server 20.04 LTS
  default = "ami-04505e74c0741db8d"
}
