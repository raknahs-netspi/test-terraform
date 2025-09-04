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
  region = "us-south"
}

# 🚩 ERROR: Missing resource type
resource "ibm_is_instance" {
  name = "broken-instance"
}

# 🚩 ERROR: Reference to undefined variable
output "test_output" {
  value = var.nonexistent_var
}
