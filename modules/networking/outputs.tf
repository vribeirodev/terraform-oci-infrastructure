output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.main.id
}

output "vcn_cidr_blocks" {
  description = "CIDR blocks of the VCN"
  value       = oci_core_vcn.main.cidr_blocks
}

output "internet_gateway_id" {
  description = "OCID of the Internet Gateway"
  value       = oci_core_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "OCID of the NAT Gateway"
  value       = oci_core_nat_gateway.main.id
}

output "public_subnet_id" {
  description = "OCID of the public subnet"
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "OCID of the private subnet"
  value       = oci_core_subnet.private.id
}

output "public_route_table_id" {
  description = "OCID of the public route table"
  value       = oci_core_route_table.public.id
}

output "private_route_table_id" {
  description = "OCID of the private route table"
  value       = oci_core_route_table.private.id
}

output "public_security_list_id" {
  description = "OCID of the public security list"
  value       = oci_core_security_list.public.id
}

output "private_security_list_id" {
  description = "OCID of the private security list"
  value       = oci_core_security_list.private.id
}

output "availability_domains" {
  description = "Available availability domains"
  value       = data.oci_identity_availability_domains.ads.availability_domains
}