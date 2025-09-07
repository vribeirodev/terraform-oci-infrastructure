variable "compartment_id" {
  description = "OCID do compartimento OCI"
  type        = string
}

variable "region" {
  description = "Região OCI"
  type        = string
  default     = "us-ashburn-1"
}

variable "project_name" {
  description = "Nome do projeto (usado para naming)"
  type        = string
  default     = "webapp"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso às instâncias"
  type        = string
}

variable "vcn_cidr_blocks" {
  description = "Blocos CIDR para a VCN"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
  default     = "10.0.2.0/24"
}

variable "web_server_count" {
  description = "Número de web servers (padrão: 2 para HA)"
  type        = number
  default     = 2

  validation {
    condition     = var.web_server_count >= 1 && var.web_server_count <= 4
    error_message = "Web server count deve ser entre 1 e 4."
  }
}

variable "instance_shape" {
  description = "Shape das instâncias web"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento avançado"
  type        = bool
  default     = true
}