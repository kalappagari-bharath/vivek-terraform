variable "rg_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_address" {
  type = list(any)
}
