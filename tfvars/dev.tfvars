subscription_id = "9826da94-3e69-495c-b960-dae5b7736e82"
rg_name        = "rg-a91-dev"
rg_name_code   = "a91"
rg_name_st_waf = "rga91dev"
location       = "eastus2"
environment    = "dev"
department_mt  = "mt"
department_fe  = "fe"
mi_name        = "id-a91-dev-eastus2"

##VNET - SUBNET
hubvnet_address            = ["172.22.4.0/26"]
gwsubnet_address           = ["172.22.4.0/27"]
fwsubnet_address           = ["172.22.4.32/29"]
spokevnet_address          = ["192.170.0.0/22"]
spoke_subnet_addr          = ["192.170.1.0/24"]
spoke_subnet_addr_oper     = ["192.170.2.0/27"]
mtspokevnet_address        = ["192.168.4.0/22"]
mtspoke_subnet_addr        = ["192.168.4.0/26"]
mtspoke_subnet_apim_addr   = ["192.168.5.0/29"]
mtspoke_subnet_pvtlnk_addr = ["192.168.6.0/27"]
mtspoke_subnet_mgmt        = ["192.168.7.0/28"] 


##Frontdoor
front_door_endpoint_name = "afd-rg-a91-dev"


#Keyvault
key_name = "appconfigkey"
sku_name = "standard"
value    = "kvvalue"

##Node pools values
vm_size    = "Standard_DS2_v2"
node_count = "2"

#ACR
sku = "Standard"

#WAF
waf_enabled  = "true"
sku_name_waf = "Premium_AzureFrontDoor"
mode_waf     = "Detection"

#rediscache
capacity            = "0"
sku_name_redis      = "Basic"
family_redis        = "C"
enable_non_ssl_port = "false"

#servicebus
sku_sbns = "Premium"

#storage account
account_tier             = "Standard"
account_replication_type = "LRS"

#sql
version_sql                  = "12.0"
administrator_login          = "sqladmin"
administrator_login_password = "SQL#admin795!$"
edition                      = "Standard"
collation                    = "SQL_Latin1_General_CP1_CI_AS"

#sqlvnetrule
ignore_missing_vnet_service_endpoint = true

#CosmosDB
offer_type        = "Standard"
kind              = "GlobalDocumentDB"
consistency_level = "Session"
failover_priority = 0
geo_location      = "East US2"

##APIM
apim_publisher_email = "donotreplydev@ups.com"
apim_publisher_name  = "UPS DEV"
apim_sku_name        = "Developer_1"
