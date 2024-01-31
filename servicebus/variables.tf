variable "rg_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "location" {
  type = string
}

variable "sku_sbns" {
  type = string
}

variable "servicebus_name" {
  type = string
}
variable "sbnamespace_id" {
  type = string
}
variable "default_action_sbns" {
  type = string
}
variable "public_network_access_enabled_sbns" {
  type = bool
}
variable "trusted_services_allowed_sbns" {
  type = string
}