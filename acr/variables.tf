variable "rg_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Resource location Name"
}

variable "environment" {
  type = string
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
}

variable "sku" {
  type        = string
  description = "Log Analytics workspace name"
}