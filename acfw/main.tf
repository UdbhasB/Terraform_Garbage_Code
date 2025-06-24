# Root module configuration will go here.
# It will use the modules defined in the 'modules/' directory.

locals {
  # Common tags to be applied to all resources
  common_tags = {
    "Test Name" = "ACFW2.0"
    "Test Type" = "Private"
  }

  # VM Sizes
  windows_vm_disk_size = 100
  ubuntu_vm_disk_size  = 75
  default_instance_type = "t3.medium"
  jump_server_instance_type = "t2.micro"
  jump_server_disk_size = 15

  # Naming Prefix
  naming_prefix = "ACFW-2.0"

  # Management Subnet Configuration
  management_subnet_cidr = "172.16.10.0/24"
  jump_server_private_ip = "172.16.10.5"


  # Vendor Data Structure
  vendors_data = {
    AXGATE = {
      code   = "AXE"
      subnets = {
        "172.16.101.0/24" = {
          gateway = "172.16.101.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.101.11", mgmt_ip = "172.16.10.11" },
            { name = "VM2", type = "Windows", private_ip = "172.16.101.12", mgmt_ip = "172.16.10.12" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.101.13", mgmt_ip = "172.16.10.13" },
          ]
        },
        "172.16.201.0/24" = {
          gateway = "172.16.201.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.201.11", mgmt_ip = "172.16.10.14" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.201.12", mgmt_ip = "172.16.10.15" },
          ]
        }
      }
    },
    CHECKPOINT = {
      code   = "CHKP"
      subnets = {
        "172.16.102.0/24" = {
          gateway = "172.16.102.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.102.11", mgmt_ip = "172.16.10.21" },
            { name = "VM2", type = "Windows", private_ip = "172.16.102.12", mgmt_ip = "172.16.10.22" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.102.13", mgmt_ip = "172.16.10.23" },
          ]
        },
        "172.16.202.0/24" = {
          gateway = "172.16.202.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.202.11", mgmt_ip = "172.16.10.24" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.202.12", mgmt_ip = "172.16.10.25" },
          ]
        }
      }
    },
    FORCEPOINT = {
      code   = "FPNT"
      subnets = {
        "172.16.103.0/24" = {
          gateway = "172.16.103.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.103.11", mgmt_ip = "172.16.10.31" },
            { name = "VM2", type = "Windows", private_ip = "172.16.103.12", mgmt_ip = "172.16.10.32" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.103.13", mgmt_ip = "172.16.10.33" },
          ]
        },
        "172.16.203.0/24" = {
          gateway = "172.16.203.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.203.11", mgmt_ip = "172.16.10.34" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.203.12", mgmt_ip = "172.16.10.35" },
          ]
        }
      }
    },
    FORTINET = {
      code   = "FTNT"
      subnets = {
        "172.16.104.0/24" = {
          gateway = "172.16.104.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.104.11", mgmt_ip = "172.16.10.41" },
            { name = "VM2", type = "Windows", private_ip = "172.16.104.12", mgmt_ip = "172.16.10.42" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.104.13", mgmt_ip = "172.16.10.43" },
          ]
        },
        "172.16.204.0/24" = {
          gateway = "172.16.204.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.204.11", mgmt_ip = "172.16.10.44" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.204.12", mgmt_ip = "172.16.10.45" },
          ]
        }
      }
    },
    JUNIPER = {
      code   = "JNPR"
      subnets = {
        "172.16.105.0/24" = {
          gateway = "172.16.105.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.105.11", mgmt_ip = "172.16.10.51" },
            { name = "VM2", type = "Windows", private_ip = "172.16.105.12", mgmt_ip = "172.16.10.52" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.105.13", mgmt_ip = "172.16.10.53" },
          ]
        },
        "172.16.205.0/24" = {
          gateway = "172.16.205.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.205.11", mgmt_ip = "172.16.10.54" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.205.12", mgmt_ip = "172.16.10.55" },
          ]
        }
      }
    },
    PALOALTO = {
      code   = "PANW"
      subnets = {
        "172.16.106.0/24" = {
          gateway = "172.16.106.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.106.11", mgmt_ip = "172.16.10.61" },
            { name = "VM2", type = "Windows", private_ip = "172.16.106.12", mgmt_ip = "172.16.10.62" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.106.13", mgmt_ip = "172.16.10.63" },
          ]
        },
        "172.16.206.0/24" = {
          gateway = "172.16.206.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.206.11", mgmt_ip = "172.16.10.64" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.206.12", mgmt_ip = "172.16.10.65" },
          ]
        }
      }
    },
    SONICWALL = {
      code   = "SWAL"
      subnets = {
        "172.16.107.0/24" = {
          gateway = "172.16.107.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.107.11", mgmt_ip = "172.16.10.71" },
            { name = "VM2", type = "Windows", private_ip = "172.16.107.12", mgmt_ip = "172.16.10.72" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.107.13", mgmt_ip = "172.16.10.73" },
          ]
        },
        "172.16.207.0/24" = {
          gateway = "172.16.207.254"
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.207.11", mgmt_ip = "172.16.10.74" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.207.12", mgmt_ip = "172.16.10.75" },
          ]
        }
      }
    },
    SOPHOS = {
      code   = "SPHS"
      subnets = {
        "172.16.108.0/24" = {
          gateway = "172.16.108.254"
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.108.11", mgmt_ip = "172.16.10.81" },
            { name = "VM2", type = "Windows", private_ip = "172.16.108.12", mgmt_ip = "172.16.10.82" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.108.13", mgmt_ip = "172.16.10.83" },
          ]
        },
        "172.16.208.0/24" = { 
          gateway = "172.16.208.254" 
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.208.11", mgmt_ip = "172.16.10.84" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.208.12", mgmt_ip = "172.16.10.85" }, 
          ]
        }
      }
    },
    "VERSA NETWORKS" = { 
      code   = "VRSN"
      subnets = {
        "172.16.109.0/24" = {
          gateway = "172.16.109.254" 
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.109.11", mgmt_ip = "172.16.10.91" },
            { name = "VM2", type = "Windows", private_ip = "172.16.109.12", mgmt_ip = "172.16.10.92" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.109.13", mgmt_ip = "172.16.10.93" },
          ]
        },
        "172.16.209.0/24" = {
          gateway = "172.16.209.254" 
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.209.11", mgmt_ip = "172.16.10.94" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.209.12", mgmt_ip = "172.16.10.95" },
          ]
        }
      }
    },
    WATCHGUARD = {
      code   = "WGTN"
      subnets = {
        "172.16.110.0/24" = {
          gateway = "172.16.110.254" 
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.110.11", mgmt_ip = "172.16.10.101" },
            { name = "VM2", type = "Windows", private_ip = "172.16.110.12", mgmt_ip = "172.16.10.102" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.110.13", mgmt_ip = "172.16.10.103" },
          ]
        },
        "172.16.210.0/24" = {
          gateway = "172.16.210.254" 
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.210.11", mgmt_ip = "172.16.10.104" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.210.12", mgmt_ip = "172.16.10.105" },
          ]
        }
      }
    },
    BARRACUDA = {
      code   = "CUDA"
      subnets = {
        "172.16.111.0/24" = {
          gateway = "172.16.111.254" 
          vms = [
            { name = "VM1", type = "Windows", private_ip = "172.16.111.11", mgmt_ip = "172.16.10.111" },
            { name = "VM2", type = "Windows", private_ip = "172.16.111.12", mgmt_ip = "172.16.10.112" },
            { name = "VM3", type = "Ubuntu",  private_ip = "172.16.111.13", mgmt_ip = "172.16.10.113" },
          ]
        },
        "172.16.211.0/24" = {
          gateway = "172.16.211.254" 
          vms = [
            { name = "VM1", type = "Ubuntu", private_ip = "172.16.211.11", mgmt_ip = "172.16.10.114" },
            { name = "VM2", type = "Ubuntu", private_ip = "172.16.211.12", mgmt_ip = "172.16.10.115" },
          ]
        }
      }
    }
  }
}

# --- VPC ---
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "172.16.0.0/16" 
  vpc_name       = "${local.naming_prefix}-VPC"
  tags           = local.common_tags
}

# --- Internet Gateway ---
module "igw" {
  source = "./modules/internet_gateway"

  vpc_id   = module.vpc.vpc_id
  igw_name = "${local.naming_prefix}-INTERNET-GATEWAY"
  tags     = local.common_tags
}

# --- Public Access Security Group ---
module "public_access_sg" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
  sg_name = "${local.naming_prefix}-PUBLIC-ACCESS-SECURITY-GROUP"
  sg_description = "Allow SSH, RDP, ICMP, VNC access from anywhere"
  
  ingress_rules = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow RDP"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow ICMP (Ping)"
      from_port   = -1 
      to_port     = -1 
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow VNC (e.g., port 5900, 5901)"
      from_port   = 5900
      to_port     = 5901
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = local.common_tags
}

# --- Management Subnet ---
module "management_subnet" {
  source = "./modules/subnet"

  vpc_id            = module.vpc.vpc_id
  subnet_cidr_block = local.management_subnet_cidr
  availability_zone = var.availability_zones[0] 
  subnet_name       = "${local.naming_prefix}-MANAGEMENT-SUBNET"
  map_public_ip_on_launch = true # Corrected: Management subnet should allow public IPs
  tags              = local.common_tags
}

# --- Public Route Table for Management Subnet ---
module "management_route_table" {
  source = "./modules/route_table"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = [module.management_subnet.subnet_id] # Corrected: use subnet_ids (list)
  routes = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.igw.internet_gateway_id
  }]
  route_table_name = "${local.naming_prefix}-MANAGEMENT-PUBLIC-RT"
  tags        = local.common_tags
}

# --- Jump Server ---
module "jump_server" {
  source = "./modules/ec2_instance"

  instance_name = "${local.naming_prefix}-JUMP-SERVER"
  ami_id        = var.ubuntu_ami_id 
  instance_type = local.jump_server_instance_type
  key_name      = var.ssh_key_name
  disk_size     = local.jump_server_disk_size

  # primary_eni_subnet_id is not needed here as network_interfaces defines the primary ENI (device_index = 0)
  # The ec2_instance module's internal logic will pick the subnet_id from the device_index = 0 ENI.
  network_interfaces = [
    {
      subnet_id   = module.management_subnet.subnet_id
      private_ip  = local.jump_server_private_ip
      description = "${local.naming_prefix}-JUMP-SERVER-MANAGEMENT-SUBNET-ENI"
      device_index = 0 # This is the primary ENI
      security_group_ids = [module.public_access_sg.security_group_id]
    }
  ]
  
  tags = merge(local.common_tags, {
    "Name" = "${local.naming_prefix}-JUMP-SERVER"
  })
}

# --- Elastic IP for Jump Server ---
module "jump_server_eip" {
  source = "./modules/elastic_ip"

  # Corrected: Use the explicit output for network interface details
  network_interface_id = module.jump_server.network_interfaces_details["0"].id 
  eip_name             = "${local.naming_prefix}-JUMP-SERVER-ELASTIC-IP"
  tags = merge(local.common_tags, {
    "Name" = "${local.naming_prefix}-JUMP-SERVER-ELASTIC-IP"
  })
  depends_on = [module.jump_server] 
}


# --- Vendor Specific Resources ---
# Placeholder for the vendor_setup module structure
# This module will be created in a subsequent step.
/*
module "vendor_resources" {
  source = "./modules/vendor_setup" 

  for_each = local.vendors_data

  vpc_id            = module.vpc.vpc_id
  management_subnet_id = module.management_subnet.subnet_id
  public_sg_id      = module.public_access_sg.security_group_id
  naming_prefix     = local.naming_prefix
  common_tags       = local.common_tags
  
  vendor_name       = each.key
  vendor_code       = each.value.code
  vendor_subnets_data = each.value.subnets

  windows_ami_id    = var.windows_ami_id
  ubuntu_ami_id     = var.ubuntu_ami_id
  default_instance_type = local.default_instance_type
  windows_vm_disk_size = local.windows_vm_disk_size
  ubuntu_vm_disk_size  = local.ubuntu_vm_disk_size
  ssh_key_name      = var.ssh_key_name
  availability_zones = var.availability_zones 

  depends_on = [
    module.vpc,
    module.management_subnet,
    module.public_access_sg,
    module.management_route_table // Ensure management network is fully up
  ]
}
*/

# Note on Private Gateways from the table:
# The "Private Gateway" IPs (e.g., 172.16.101.254) are not automatically created as separate AWS gateway resources by this Terraform.
# If these are meant to be router/firewall virtual appliances, they would need to be defined as EC2 instances
# (potentially one of the VMs listed for a vendor, or a separate set of VMs).
# VMs in private subnets will use the VPC's implicit router for intra-VPC communication.
# OS-level configuration on VMs would be needed if they must use a specific IP (like .254) as their gateway,
# and a device (VM) must exist at that IP and be configured for routing.
# The current Terraform setup creates the subnets and the listed VMs with their specified private IPs.
# Route tables for private subnets created within the (future) vendor_setup module will initially only have local VPC routes.
# If NAT Gateways or other specific routing via these ".254" IPs are required, the vendor_setup module and its
# use of the route_table module would need to be designed accordingly, potentially creating NAT Gateway resources
# or adding routes pointing to the ENIs of firewall/router VMs (if those VMs are created with the .254 IPs).
# For now, the 'gateway' field in 'locals.vendors_data' is informational.
