variable "subscription_id" {
  type = string
}

variable "rg_name" {
  type        = string
  description = "Azure Resource Group Name"
}
variable "rg_name_code" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "rg_name_st_waf" {
  type        = string
  description = "Azure Resource Group Name for Storage account and WAF"
}

variable "environment" {
  type        = string
  description = "Azure Resource Environment"
}

variable "location" {
  type        = string
  description = "Azure Resource location Name"
}

#Managed Identity
variable "mi_name" {
  type = string
}

# variable "spoke_subnet_addr_2" {
#   type        = list(any)
#   description = "This variable defines the address space for Firewall subnet"
# }

variable "hubvnet_address" {
  type        = list(any)
  description = "This variable defines the address space for Hub vnet"
}

variable "gwsubnet_address" {
  type        = list(any)
  description = "This variable defines the address space for Gatewaysubnet"
}

variable "fwsubnet_address" {
  type        = list(any)
  description = "This variable defines the address space for Firewall subnet"
}

variable "spokevnet_address" {
  type        = list(any)
  description = "This variable defines the address space for Hub vnet"
}
variable "spoke_subnet_addr" {
  type        = list(any)
  description = "This variable defines the address space for Firewall subnet"
}



variable "front_door_endpoint_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "value" {
  type = string
}

variable "key_name" {}

variable "sku_name_waf" {
  type = string
}
variable "waf_enabled" {
  type = string
}

variable "mode_waf" {
  type = string
}

#node pool

variable "vm_size" {
  type = string
}

variable "node_count" {
  type = string
}

#Azure Container Registry

variable "sku" {
  type = string
}

variable "mtspokevnet_address" {
  type        = list(any)
  description = "This variable defines the address space for Hub vnet"
}

variable "spoke_subnet_addr_oper" {
  type        = list(any)
  description = "This variable defines the address space for Hub vnet"
}

variable "mtspoke_subnet_mgmt" {
  type        = list(any)
  description = "This variable defines the address space for Hub vnet"
}
variable "mtspoke_subnet_addr" {
  type        = list(any)
  description = "This variable defines the address space for Firewall subnet"
}

variable "mtspoke_subnet_apim_addr" {
  type        = list(any)
  description = "This variable defines the address space for Firewall subnet"
}

variable "mtspoke_subnet_pvtlnk_addr" {
  type        = list(any)
  description = "This variable defines the address space for Firewall subnet"
}

variable "department_fe" {
  type = string
}

variable "department_mt" {
  type = string
}

variable "capacity" {
  type = string
}

variable "sku_name_redis" {
  type = string
}

variable "family_redis" {
  type = string
}

variable "enable_non_ssl_port" {
  type = string
}

variable "sku_sbns" {
  type = string
}

variable "account_tier" {
  description = "Azure Resource for storage account tier"
}

variable "account_replication_type" {
  description = "Azure Resource for storage account replication type"
}

variable "version_sql" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "administrator_login_password" {
  type = string
}

variable "edition" {
  type = string
}

variable "collation" {
  type = string
}

variable "offer_type" {
  type = string
}

variable "kind" {
  type = string
}

variable "consistency_level" {
  type = string
}

variable "failover_priority" {
  type = string
}

variable "geo_location" {
  type = string
}

##APIM
variable "apim_publisher_email" {
  type = string
}

variable "apim_publisher_name" {
  type = string
}

variable "apim_sku_name" {
  type = string
}

variable "ignore_missing_vnet_service_endpoint" {
  type = string
}
