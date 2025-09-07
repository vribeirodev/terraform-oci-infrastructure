variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "vcn_name" {
  description = "Display name for the VCN"
  type        = string
  default     = "main-vcn"
}

variable "vcn_cidr_blocks" {
  description = "CIDR blocks for the VCN"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_domain" {
  description = "Availability domain for subnets"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}