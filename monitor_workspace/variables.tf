variable "rg_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Resource location Name"
}

variable "environment" {
  type        = string
  description = "Azure Resource Environment"
}

variable "amw_name" {
  type        = string
  description = "Azure Monitor workspace name"
}