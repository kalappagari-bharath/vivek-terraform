variable "rg_name" {
  type = string
}

variable "rg_name_code" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "front_door_sku_name" {
  type        = string
  description = "The SKU for the Front Door profile. Possible values include: Standard_AzureFrontDoor, Premium_AzureFrontDoor"
  default     = "Premium_AzureFrontDoor"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku_name)
    error_message = "The SKU value must be one of the following: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
}

variable "vnet_subnet_id" {
  type = string
}

variable "loadbalancer_id" {
  type = list(any)
}

variable "loadbalancer_ip" {
  type = list(any)
}

variable "aks_rg" {
  type = string
}

variable "front_door_profile_name" {
  type = string
}

variable "front_door_endpoint_name" {
  type = string
}

variable "front_door_origin_group_name" {
  type    = string
  default = "MyOriginGroup"
}

variable "front_door_origin_name" {
  type    = string
  default = "MyAppServiceOrigin"
}

variable "front_door_route_name" {
  type    = string
  default = "MyRoute"
}

variable "front_door_endpoint_name_mt" {
  type = string
}

variable "front_door_origin_group_name_mt" {
  type = string
}

variable "front_door_origin_name_mt" {
  type = string
}

variable "front_door_route_name_mt" {
  type = string
}

variable "mt_app_service_origin_host_name" {
  type = string
}

variable "mt_app_service_origin_host_header" {
  type = string
}
