variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}

variable "private_service_connection_name" {
  type = string
}

variable "private_connection_resource_id" {
  type = string
}

variable "subresource_names" {
  type = list(any)
}

variable "private_dns_zone_group_name" {
  type = string
}

variable "private_dns_zone_name" {
  type = string
}

variable "private_dns_a_record_name" {
  type = string
}

variable "private_dns_a_record_records" {
  type = list(any)
}

variable "private_dns_zone_virtual_network_link_name" {
  type = string
}

variable "private_dns_zone_virtual_network_link_virtual_network_id" {
  type = string
}
