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
  default     = "basic-infra"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
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
