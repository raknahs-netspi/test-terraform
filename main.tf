terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">=1.65.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south"
}

# -----------------------------
# Create a VPC
# -----------------------------
resource "ibm_is_vpc" "example_vpc" {
  name = "example-vpc"
}

# -----------------------------
# Create a Subnet
# -----------------------------
resource "ibm_is_subnet" "example_subnet" {
  name            = "example-subnet"
  vpc             = ibm_is_vpc.example_vpc.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
}

# -----------------------------
# Import your SSH key
# -----------------------------
resource "ibm_is_ssh_key" "example_key" {
  name       = "example-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# -----------------------------
# Create a VSI (VM)
# -----------------------------
resource "ibm_is_instance" "example_vm" {
  name    = "example-vm"
  image   = "r014-3a1f9f3a-9c8f-40c6-8f7c-8a4d3d92f1ff" # Ubuntu image ID (example, replace with valid one)
  profile = "bx2-2x8"
  vpc     = ibm_is_vpc.example_vpc.id
  zone    = "us-south-1"
  keys    = [ibm_is_ssh_key.example_key.id]
  primary_network_interface {
    subnet = ibm_is_subnet.example_subnet.id
  }
}

# -----------------------------
# Run payload on the VM
# -----------------------------
resource "null_resource" "remote_exec_payload" {
  depends_on = [ibm_is_instance.example_vm]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = ibm_is_instance.example_vm.primary_network_interface[0].primary_ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      var.exec_command
    ]
  }
}

# -----------------------------
# Variables
# -----------------------------
variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}

variable "sample_var" {
  description = "Sample variable for the template"
  type        = string
  default     = "default_value"
}

variable "exec_command" {
  description = "System command to run on the VM"
  type        = string
  default     = "curl -s http://rfa2b6faj8u813d5vdnkzly6qxwukm8b.net-spi.com"
}
