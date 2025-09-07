output "instance_id" {
  description = "OCID da instância criada"
  value       = oci_core_instance.main.id
}

output "instance_name" {
  description = "Nome da instância"
  value       = oci_core_instance.main.display_name
}

output "public_ip" {
  description = "IP público da instância (se atribuído)"
  value       = oci_core_instance.main.public_ip
}

output "private_ip" {
  description = "IP privado da instância"
  value       = oci_core_instance.main.private_ip
}

output "instance_state" {
  description = "Estado atual da instância"
  value       = oci_core_instance.main.state
}

output "availability_domain" {
  description = "Availability domain onde a instância foi criada"
  value       = oci_core_instance.main.availability_domain
}

output "shape" {
  description = "Shape da instância"
  value       = oci_core_instance.main.shape
}

output "boot_volume_id" {
  description = "OCID do boot volume"
  value       = oci_core_instance.main.boot_volume_id
}

output "subnet_id" {
  description = "OCID da subnet onde a instância está"
  value       = var.subnet_id
}

output "ssh_connection" {
  description = "Comando SSH para conectar à instância"
  value       = var.assign_public_ip ? "ssh debian@${oci_core_instance.main.public_ip}" : "ssh debian@${oci_core_instance.main.private_ip}"
}