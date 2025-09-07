variable "compartment_id" {
  description = "OCID do compartimento"
  type        = string
}

variable "subnet_id" {
  description = "OCID da subnet onde criar a instância"
  type        = string
}

variable "instance_name" {
  description = "Nome da instância"
  type        = string
  default     = "compute-instance"
}

variable "instance_shape" {
  description = "Shape da instância"
  type        = string
  default     = "VM.Standard.E2.1.Micro" # Always Free eligible
}

variable "instance_image_id" {
  description = "OCID da imagem (opcional, usa Debian 12 se não especificado)"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso à instância"
  type        = string
}

variable "user_data" {
  description = "Script de inicialização (cloud-init)"
  type        = string
  default     = null
}

variable "assign_public_ip" {
  description = "Atribuir IP público à instância"
  type        = bool
  default     = false
}

variable "availability_domain" {
  description = "Availability domain para a instância"
  type        = string
}

variable "fault_domain" {
  description = "Fault domain (opcional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags para aplicar à instância"
  type        = map(string)
  default     = {}
}