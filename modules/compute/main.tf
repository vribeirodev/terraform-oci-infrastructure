terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Data source para pegar a imagem mais recente do Debian se não especificada
data "oci_core_images" "debian" {
  count = var.instance_image_id == null ? 1 : 0

  compartment_id           = var.compartment_id
  operating_system         = "Debian"
  operating_system_version = "12"
  shape                    = var.instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Debian-12.*$"]
    regex  = true
  }

  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# Compute Instance
resource "oci_core_instance" "main" {
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  fault_domain        = var.fault_domain
  display_name        = var.instance_name
  shape               = var.instance_shape

  # Shape config para shapes flexíveis
  dynamic "shape_config" {
    for_each = can(regex("^.*Flex$", var.instance_shape)) ? [1] : []
    content {
      ocpus         = 1
      memory_in_gbs = 1
    }
  }

  # Configuração da instância
  source_details {
    source_id   = var.instance_image_id != null ? var.instance_image_id : data.oci_core_images.debian[0].images[0].id
    source_type = "image"
  }

  # Configuração de rede
  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = var.assign_public_ip
    display_name           = "${var.instance_name}-vnic"
    hostname_label         = replace(var.instance_name, "-", "")
    skip_source_dest_check = false
  }

  # Metadados para SSH e user data
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = var.user_data != null ? base64encode(var.user_data) : null
  }

  # Tags
  freeform_tags = var.tags

  # Evita destruição acidental
  lifecycle {
    ignore_changes = [
      source_details[0].source_id,
    ]
  }
}

# Boot Volume Backup Policy (opcional para ambientes críticos)
resource "oci_core_volume_backup_policy_assignment" "main" {
  count = var.tags["Environment"] == "prod" ? 1 : 0

  asset_id  = oci_core_instance.main.boot_volume_id
  policy_id = data.oci_core_volume_backup_policies.builtin_policies.volume_backup_policies[0].id
}

# Data source para políticas de backup padrão
data "oci_core_volume_backup_policies" "builtin_policies" {
  filter {
    name   = "display_name"
    values = ["silver"]
  }
}