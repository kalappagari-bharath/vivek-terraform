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

variable "address_space" {
  type = list(any)
}

