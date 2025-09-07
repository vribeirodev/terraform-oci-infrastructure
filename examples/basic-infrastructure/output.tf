output "vcn_id" {
  description = "OCID da VCN criada"
  value       = module.networking.vcn_id
}

output "public_subnet_id" {
  description = "OCID da subnet pública"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "OCID da subnet privada"
  value       = module.networking.private_subnet_id
}

output "internet_gateway_id" {
  description = "OCID do Internet Gateway"
  value       = module.networking.internet_gateway_id
}

output "project_info" {
  description = "Informações do projeto"
  value = {
    name        = var.project_name
    environment = var.environment
    region      = var.region
  }
}