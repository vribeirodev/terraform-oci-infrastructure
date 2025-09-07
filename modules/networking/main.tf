terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Data source to get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# VCN
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  cidr_blocks    = var.vcn_cidr_blocks
  dns_label      = replace(var.vcn_name, "-", "")

  freeform_tags = var.tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-igw"
  enabled        = true

  freeform_tags = var.tags
}

# NAT Gateway
resource "oci_core_nat_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-nat"

  freeform_tags = var.tags
}

# Route Table for Public Subnet
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main.id
  }

  freeform_tags = var.tags
}

# Route Table for Private Subnet
resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.main.id
  }

  freeform_tags = var.tags
}

# Security List for Public Subnet
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-public-sl"

  # Ingress rules
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Egress rules
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  freeform_tags = var.tags
}

# Security List for Private Subnet
resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.vcn_name}-private-sl"

  # Ingress from VCN
  ingress_security_rules {
    protocol    = "all"
    source      = var.vcn_cidr_blocks[0]
    source_type = "CIDR_BLOCK"
  }

  # Egress all
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  freeform_tags = var.tags
}

# Public Subnet
resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  cidr_block     = var.public_subnet_cidr
  display_name   = "${var.vcn_name}-public-subnet"
  dns_label      = "public"

  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false

  availability_domain = var.availability_domain

  freeform_tags = var.tags
}

# Private Subnet
resource "oci_core_subnet" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  cidr_block     = var.private_subnet_cidr
  display_name   = "${var.vcn_name}-private-subnet"
  dns_label      = "private"

  route_table_id             = oci_core_route_table.private.id
  security_list_ids          = [oci_core_security_list.private.id]
  prohibit_public_ip_on_vnic = true

  availability_domain = var.availability_domain

  freeform_tags = var.tags
}