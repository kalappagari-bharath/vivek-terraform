variable "rg_name" {
  type        = string
  description = "Azure Resource Group Name"
}
variable "environment" {
  type        = string
  description = "Azure Resource Environment"
}
variable "location" {
  type        = string
  description = "Azure Resource location Name"
}
variable "peering_name" {
  type        = string
  description = "This variable defines the vnet Peering Connection Name"
}
# variable "virtual_network_id" {
#   type        = string
#   description = "This variable defines the ID of Hub network"
# }

variable "virtual_network_name" {
  type        = string
  description = "This variable defines the ID of Hub network"
}
variable "remote_virtual_network_id" {
  type        = string
  description = "This variable defines ID of spoke network"
}
variable "allow_gateway_transit" {
  type        = bool
  description = "Whether to allow gateway transit"
}
variable "allow_forwarded_traffic" {
  type        = bool
  description = "Whether to allow forward traffic"
}
variable "use_remote_gateway" {
  type        = bool
  description = "Whether to use remote gateway"
}


