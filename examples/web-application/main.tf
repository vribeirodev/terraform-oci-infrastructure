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
  vcn_name            = "${var.project_name}-vpc"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  vcn_cidr_blocks     = var.vcn_cidr_blocks
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  tags = local.common_tags
}

# Web Server User Data
locals {
  web_server_user_data = base64encode(templatefile("${path.module}/scripts/web_server_init.sh", {
    server_name = var.project_name
  }))

  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Purpose     = "web-application"
  }
}

# Web Server 1
module "web_server_1" {
  source = "../../modules/compute"

  compartment_id      = var.compartment_id
  subnet_id           = module.networking.public_subnet_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  instance_name    = "${var.project_name}-web-1"
  ssh_public_key   = var.ssh_public_key
  assign_public_ip = true
  user_data        = local.web_server_user_data

  tags = local.common_tags
}

# Web Server 2
module "web_server_2" {
  source = "../../modules/compute"

  compartment_id      = var.compartment_id
  subnet_id           = module.networking.public_subnet_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  instance_name    = "${var.project_name}-web-2"
  ssh_public_key   = var.ssh_public_key
  assign_public_ip = true
  user_data        = local.web_server_user_data

  tags = local.common_tags
}

# Network Load Balancer
resource "oci_network_load_balancer_network_load_balancer" "web_lb" {
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-nlb"
  subnet_id      = module.networking.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false

  freeform_tags = local.common_tags
}

# Backend Set
resource "oci_network_load_balancer_backend_set" "web_backend_set" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.web_lb.id
  name                     = "web-backend-set"
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol = "HTTP"
    port     = 80
    url_path = "/"

    return_code        = 200
    timeout_in_millis  = 3000
    interval_in_millis = 10000
    retries            = 3
  }
}

# Backend Servers
resource "oci_network_load_balancer_backend" "web_backend_1" {
  backend_set_name         = oci_network_load_balancer_backend_set.web_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.web_lb.id
  port                     = 80
  target_id                = module.web_server_1.instance_id
}

resource "oci_network_load_balancer_backend" "web_backend_2" {
  backend_set_name         = oci_network_load_balancer_backend_set.web_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.web_lb.id
  port                     = 80
  target_id                = module.web_server_2.instance_id
}

# Listener
resource "oci_network_load_balancer_listener" "web_listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.web_lb.id
  name                     = "web-listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.web_backend_set.name
  port                     = 80
  protocol                 = "TCP"
}