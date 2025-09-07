terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Configure the OCI Provider
provider "oci" {
  region = var.region
}

# Data source to get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Networking module
module "networking" {
  source = "../../modules/networking"

  compartment_id      = var.compartment_id
  vcn_name            = var.project_name
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  vcn_cidr_blocks     = var.vcn_cidr_blocks
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
