data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

module "acr" {
  source      = "./acr"
  rg_name     = var.rg_name
  acr_name    = "acr${var.rg_name_code}${var.environment}${var.location}"
  location    = var.location
  environment = var.environment
  sku         = var.sku
}

module "aks_fe" {
  source                  = "./aks"
  rg_name                 = var.rg_name
  location                = var.location
  mi_name                 = var.mi_name
  vnet_name               = module.frontend-spoke-vnet.vnet_name
  aks_name                = "aks-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
  vnet_subnet_id          = module.frontend-spoke-subnet.subnet_id
  environment             = var.environment
  law_id                  = module.loganalyticsworkspace.law_id
  private_cluster_enabled = false
}

module "aks_mt" {
  source                  = "./aks"
  rg_name                 = var.rg_name
  location                = var.location
  mi_name                 = var.mi_name
  vnet_name               = module.middletier-vnet.vnet_name
  aks_name                = "aks-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
  vnet_subnet_id          = module.middletier_aks_subnet.subnet_id
  environment             = var.environment
  law_id                  = module.loganalyticsworkspace.law_id
  private_cluster_enabled = false
}


module "nodepool-fe1" {
  source         = "./nodepool"
  node_pool_name = "webui01"
  aks_id         = module.aks_fe.aks_id
  vm_size        = var.vm_size
  node_count     = var.node_count
  vnet_subnet_id = module.frontend-spoke-subnet.subnet_id
}

module "nodepool-mt1" {
  source         = "./nodepool"
  node_pool_name = "api01"
  aks_id         = module.aks_mt.aks_id
  vm_size        = var.vm_size
  node_count     = var.node_count
  vnet_subnet_id = module.middletier_aks_subnet.subnet_id
}

module "loadbalancer_frontend" {
  source                 = "./loadbalancer"
  aks_rg                 = module.aks_fe.aks_rg
  host                   = module.aks_fe.host
  client_key             = module.aks_fe.client_key
  client_certificate     = module.aks_fe.client_certificate
  cluster_ca_certificate = module.aks_fe.cluster_ca_certificate
  selector               = "app.kubernetes.io/name: ingress-nginx"
}

module "ingress_frontend" {
  source                 = "./ingress"
  host                   = module.aks_fe.host
  client_key             = module.aks_fe.client_key
  client_certificate     = module.aks_fe.client_certificate
  cluster_ca_certificate = module.aks_fe.cluster_ca_certificate
}

module "namespace_web01" {
  source                 = "./namespace"
  namespace_name         = "web01"
  host                   = module.aks_fe.host
  client_key             = module.aks_fe.client_key
  client_certificate     = module.aks_fe.client_certificate
  cluster_ca_certificate = module.aks_fe.cluster_ca_certificate
}

module "namespace_web02" {
  source                 = "./namespace"
  namespace_name         = "web02"
  host                   = module.aks_fe.host
  client_key             = module.aks_fe.client_key
  client_certificate     = module.aks_fe.client_certificate
  cluster_ca_certificate = module.aks_fe.cluster_ca_certificate
}

module "monitor_workspace" {
  source      = "./monitor_workspace"
  rg_name     = var.rg_name
  amw_name    = "amw-${var.rg_name_code}-${var.environment}-${var.location}"
  location    = var.location
  environment = var.environment
}

module "prometheus_rule_group_web" {
  source                                     = "./prometheus_rule_group"
  rg_name                                    = var.rg_name
  location                                   = var.location
  environment                                = var.environment
  dce_name                                   = "MSProm-${var.location}-${module.aks_fe.aks_name}"
  dcr_name                                   = "MSProm-${var.location}-${module.aks_fe.aks_name}"
  dcra_name                                  = "MSProm-${var.location}-${module.aks_fe.aks_name}"
  aks_name                                   = module.aks_fe.aks_name
  aks_id                                     = module.aks_fe.aks_id
  amw_id                                     = module.monitor_workspace.amw_id
  node_recording_rules_rule_group_name       = "NodeRecordingRulesRuleGroup-${module.aks_fe.aks_name}"
  kubernetes_recording_rules_rule_group_name = "KubernetesRecordingRulesRuleGroup-${module.aks_fe.aks_name}"
}

module "prometheus_rule_group_api" {
  source                                     = "./prometheus_rule_group"
  rg_name                                    = var.rg_name
  location                                   = var.location
  environment                                = var.environment
  dce_name                                   = "MSProm-${var.location}-${module.aks_mt.aks_name}"
  dcr_name                                   = "MSProm-${var.location}-${module.aks_mt.aks_name}"
  dcra_name                                  = "MSProm-${var.location}-${module.aks_mt.aks_name}"
  aks_name                                   = module.aks_mt.aks_name
  aks_id                                     = module.aks_mt.aks_id
  amw_id                                     = module.monitor_workspace.amw_id
  node_recording_rules_rule_group_name       = "NodeRecordingRulesRuleGroup-${module.aks_mt.aks_name}"
  kubernetes_recording_rules_rule_group_name = "KubernetesRecordingRulesRuleGroup-${module.aks_mt.aks_name}"
}

module "frontend-spoke-vnet" {
  source        = "./network/vnet"
  rg_name       = var.rg_name
  location      = var.location
  address_space = var.spokevnet_address
  environment   = var.environment
  vnet_name     = "vnet-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
}

# module "hub-vnet" {
#   source        = "./network/vnet"
#   rg_name       = var.rg_name
#   location      = var.location
#   address_space = var.hubvnet_address
#   environment   = var.environment
#   vnet_name     = "hvnet-${var.rg_name}-${var.environment}-${var.location}"
# }

module "middletier-vnet" {
  source        = "./network/vnet"
  rg_name       = var.rg_name
  location      = var.location
  address_space = var.mtspokevnet_address
  environment   = var.environment
  vnet_name     = "vnet-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"

}

module "frontend-spoke-subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.spoke_subnet_addr
  environment    = var.environment
  vnet_name      = module.frontend-spoke-vnet.vnet_name
  subnet_name    = "snet-aks-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
}

module "frontend-spoke-operational-subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.spoke_subnet_addr_oper
  environment    = var.environment
  vnet_name      = module.frontend-spoke-vnet.vnet_name
  subnet_name    = "snet-mgmt-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
}

# module "hub-gatewaysubnet" {
#   source         = "./network/subnet"
#   rg_name        = var.rg_name
#   location       = var.location
#   subnet_address = var.gwsubnet_address
#   environment    = var.environment
#   vnet_name      = module.hub-vnet.vnet_name
#   subnet_name    = "gatewaysubnet-${var.rg_name}-${var.environment}-${var.location}"
# }

# module "hub-firewallsubnet" {
#   source         = "./network/subnet"
#   rg_name        = var.rg_name
#   location       = var.location
#   subnet_address = var.fwsubnet_address
#   environment    = var.environment
#   vnet_name      = module.hub-vnet.vnet_name
#   subnet_name    = "firewallsubnet-${var.rg_name}-${var.environment}-${var.location}"
# }

module "middletier_aks_subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.mtspoke_subnet_addr
  environment    = var.environment
  vnet_name      = module.middletier-vnet.vnet_name
  subnet_name    = "snet-aks-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
}

module "middletier_apim_subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.mtspoke_subnet_apim_addr
  environment    = var.environment
  vnet_name      = module.middletier-vnet.vnet_name
  subnet_name    = "snet-apim-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
}

module "middletier_pvtlnk_subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.mtspoke_subnet_pvtlnk_addr
  environment    = var.environment
  vnet_name      = module.middletier-vnet.vnet_name
  subnet_name    = "snet-pvtlnk-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
}

module "middle-spoke-operational-subnet" {
  source         = "./network/subnet"
  rg_name        = var.rg_name
  location       = var.location
  subnet_address = var.mtspoke_subnet_mgmt
  environment    = var.environment
  vnet_name      = module.middletier-vnet.vnet_name
  subnet_name    = "snet-mgmt-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
}
module "nsg-spokesubnet" {
  source      = "./network/nsg"
  rg_name     = var.rg_name
  location    = var.location
  environment = var.environment
  nsg_name    = "nsg-aks-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
  subnet_id   = module.frontend-spoke-subnet.subnet_id

}

module "nsg-middletier_akssubnet" {
  source      = "./network/nsg"
  rg_name     = var.rg_name
  location    = var.location
  environment = var.environment
  nsg_name    = "nsg-aks-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
  subnet_id   = module.middletier_aks_subnet.subnet_id

}

module "nsg-middletier_apimsubnet" {
  source      = "./network/nsg"
  rg_name     = var.rg_name
  location    = var.location
  environment = var.environment
  nsg_name    = "nsg-apim-${var.rg_name_code}-${var.environment}-${var.department_mt}-${var.location}"
  subnet_id   = module.middletier_apim_subnet.subnet_id
}

module "nsg_middletier_apimsubnet_inboundrule1" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagHTTPSInbound"
  priority                   = "100"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "Internet"
  destination_address_prefix = "VirtualNetwork"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}

module "nsg_middletier_apimsubnet_inboundrule2" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagCustom3443Inbound"
  priority                   = "110"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "3443"
  source_address_prefix      = "ApiManagement"
  destination_address_prefix = "VirtualNetwork"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}


module "nsg_middletier_apimsubnet_inboundrule3" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagCustom6390Inbound"
  priority                   = "120"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "6390"
  source_address_prefix      = "AzureLoadBalancer"
  destination_address_prefix = "VirtualNetwork"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}

module "nsg_middletier_apimsubnet_outboundrule1" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagCustom443OutboundStorage"
  priority                   = "130"
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "Storage"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}

module "nsg_middletier_apimsubnet_outboundrule2" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagMS_SQLOutbound"
  priority                   = "140"
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "1443"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "Internet"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}

module "nsg_middletier_apimsubnet_outboundrule3" {
  source                     = "./network/nsg_rule"
  rg_name                    = var.rg_name
  location                   = var.location
  environment                = var.environment
  nsgrule_name               = "AllowTagCustom443OutboundKeyVault"
  priority                   = "150"
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "AzureKeyVault"
  subnet_id                  = module.middletier_apim_subnet.subnet_id
  nsg_name                   = module.nsg-middletier_apimsubnet.nsg_name

}

module "routetable_spokesubnet" {
  source                    = "./network/route_table"
  rg_name                   = var.rg_name
  location                  = var.location
  environment               = var.environment
  subnet_id                 = module.frontend-spoke-subnet.subnet_id
  route_table_name          = "rt-${var.rg_name_code}-${var.environment}-${var.department_fe}-${var.location}"
  route_name                = "routetable"
  address_prefix_routetable = "192.170.0.0/16"
}

# module "peering" {
#   source                    = "./network/peering"
#   peering_name              = "hubtospokepeering-${var.rg_name}-${var.environment}-${var.location}"
#   rg_name                   = azurerm_resource_group.rg.name
#   location                  = var.location
#   environment               = var.environment
#   virtual_network_name      = "hvnet-${var.rg_name}-${var.environment}-${var.location}"
#   remote_virtual_network_id = module.spoke-vnet.network2_id
#   allow_forwarded_traffic   = true
#   allow_gateway_transit     = true
#   use_remote_gateway        = false
# }
###
module "frontdoor" {
  depends_on                        = [module.apim]
  source                            = "./frontdoor"
  rg_name                           = var.rg_name
  rg_name_code                      = var.rg_name_code
  location                          = var.location
  front_door_endpoint_name          = var.front_door_endpoint_name
  environment                       = var.environment
  vnet_subnet_id                    = module.frontend-spoke-subnet.subnet_id
  loadbalancer_id                   = module.loadbalancer_frontend.loadbalancer_id
  loadbalancer_ip                   = module.loadbalancer_frontend.loadbalancer_ip
  aks_rg                            = module.aks_fe.aks_rg
  front_door_profile_name           = "afd-${var.rg_name_code}-${var.environment}-${var.location}"
  front_door_endpoint_name_mt       = "api"
  front_door_origin_group_name_mt   = "MtOriginGroup"
  front_door_origin_name_mt         = "MtAppServiceOrigin"
  front_door_route_name_mt          = "MtRoute"
  mt_app_service_origin_host_name   = "apim-${var.rg_name_code}-${var.environment}-${var.location}.azure-api.net"
  mt_app_service_origin_host_header = "apim-${var.rg_name_code}-${var.environment}-${var.location}.azure-api.net"
  subscription_id                   = var.subscription_id
}

module "waf" {
  source             = "./waf"
  rg_name            = var.rg_name
  location           = var.location
  environment        = var.environment
  waf_name           = "waf${var.rg_name_code}${var.environment}${var.location}"
  sku_name_waf       = var.sku_name_waf
  mode_waf           = var.mode_waf
  waf_enabled        = var.waf_enabled
  afd_id             = module.frontdoor.afd_id
  frontdoor_endpoint = module.frontdoor.frontend_endpoint_name
}

module "loganalyticsworkspace" {
  source      = "./loganalyticsworkspace"
  law_name    = "log-${var.rg_name_code}-${var.environment}-${var.location}"
  environment = var.environment
  rg_name     = var.rg_name
  location    = var.location
}

module "keyvault" {
  source      = "./keyvault"
  rg_name     = var.rg_name
  location    = var.location
  environment = var.environment
  kv_name     = "kv-${var.rg_name_code}-${var.environment}-${var.location}"
  sku_name    = var.sku_name
  value       = var.value
}

module "appconfiguration" {
  source          = "./appconfiguration"
  rg_name         = var.rg_name
  location        = var.location
  environment     = var.environment
  app_config_name = "appcss-${var.rg_name_code}-${var.environment}-${var.location}"
  sku_name        = var.sku_name
  key_name        = var.key_name
}

module "appinsights" {
  source           = "./appinsights"
  rg_name          = var.rg_name
  location         = var.location
  environment      = var.environment
  app_insight_name = "appi-${var.rg_name_code}-${var.environment}-${var.location}"
  law_id           = module.loganalyticsworkspace.law_id
}

module "apim" {
  source                    = "./apim"
  rg_name                   = var.rg_name
  location                  = var.location
  environment               = var.environment
  apim_name                 = "apim-${var.rg_name_code}-${var.environment}-${var.location}"
  apim_publisher_email      = var.apim_publisher_email
  apim_publisher_name       = var.apim_publisher_name
  apim_sku_name             = var.apim_sku_name
  apim_virtual_network_type = "External"
  subnet_id                 = module.middletier_apim_subnet.subnet_id
  apim_pip_name             = "pip-apim-${var.rg_name_code}-${var.environment}-${var.location}"
  domain_name_label         = "apim-pip-${var.rg_name_code}-${var.environment}"
  apim_appinsight_name      = "apim-appi-${var.rg_name_code}-${var.environment}-${var.location}"
  instrumentation_key       = module.appinsights.app_insights_instrumentation_key
}


module "rediscache" {
  source              = "./rediscache"
  rg_name             = var.rg_name
  location            = var.location
  environment         = var.environment
  capacity            = var.capacity
  sku_name_redis      = var.sku_name_redis
  family_redis        = var.family_redis
  redis_name          = "redis-${var.rg_name_code}-${var.environment}-${var.location}"
  enable_non_ssl_port = var.enable_non_ssl_port
}

module "servicebus" {
  source                             = "./servicebus"
  rg_name                            = var.rg_name
  location                           = var.location
  environment                        = var.environment
  sku_sbns                           = var.sku_sbns
  servicebus_name                    = "sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  sbnamespace_id                     = module.servicebus.servicebus_id
  default_action_sbns                = "Allow"
  public_network_access_enabled_sbns = false
  trusted_services_allowed_sbns      = true
}


module "servicebus_queue_sbqbsisbossbrokerpacketkr" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.bsis.boss.brokerpacket.kr"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbsisbossbrokerpacketx1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.bsis.boss.brokerpacket.x1"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbossbsiscustomerx1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.boss.bsis.customer.x1"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbossbsiscustomreceivex1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.bsis.boss.customsreceive.x1"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbossbsisispsx1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.boss.bsis.isps.x1"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbossbsismassupdatex1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.boss.bsis.massupdate.x1"
  servicebus_id         = module.servicebus.servicebus_id
}

module "servicebus_queue_sbqbosspreprocessingx1" {
  source                = "./servicebus_queue"
  servicebus_queue_name = "sbq.boss.preprocessing.x1"
  servicebus_id         = module.servicebus.servicebus_id
}



module "storageaccount" {
  source                   = "./storageaccount"
  rg_name                  = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  storage_account_name     = "st${var.rg_name_code}${var.environment}${var.location}"

}

module "sql" {
  source                       = "./sql"
  rg_name                      = var.rg_name
  location                     = var.location
  environment                  = var.environment
  version_sql                  = var.version_sql
  sql_name                     = "sql-${var.rg_name_code}-${var.environment}-${var.location}"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}

module "sqldatabase" {
  source            = "./sqldatabase"
  rg_name           = var.rg_name
  location          = var.location
  environment       = var.environment
  sql_database_name = "sql-db-${var.rg_name_code}-${var.environment}-${var.location}"
  edition           = var.edition
  collation         = var.collation
  server_name       = module.sql.sql_server_name
  server_id_sql     = module.sql.sql_id
}

module "sqlvnetrule" {
  source                               = "./sqlvnetrule"
  sql_vnet_rule_name                   = "sql-vnet-rule-${var.rg_name}-${var.environment}-${var.location}"
  subnet_id_sql_vnet_rule              = module.middletier_aks_subnet.subnet_id
  server_id_sql                        = module.sql.sql_id
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint

}

module "cosnodb" {
  source            = "./cosnodb"
  rg_name           = var.rg_name
  location          = var.location
  environment       = var.environment
  cosnodb_name      = "cosno-db-${var.rg_name_code}-${var.environment}-${var.location}"
  offer_type        = var.offer_type
  kind              = var.kind
  consistency_level = var.consistency_level
  failover_priority = var.failover_priority
  geo_location      = var.geo_location
  cosnodb_id        = module.cosnodb.cosnodb_id

}

module "pep_rediscache" {
  source                                                   = "./private_endpoint"
  rg_name                                                  = var.rg_name
  location                                                 = var.location
  environment                                              = var.environment
  subnet_id                                                = module.middletier_pvtlnk_subnet.subnet_id
  private_endpoint_name                                    = "pep-redis-${var.rg_name_code}-${var.environment}-${var.location}"
  private_service_connection_name                          = "psc-${var.rg_name_code}-${var.environment}-${var.location}"
  private_connection_resource_id                           = module.rediscache.rediscache_id
  subresource_names                                        = ["redisCache"]
  private_dns_zone_group_name                              = "pvtdnszonegrp.redis-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_name                                    = "privatelink.redis-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_name                                = "redis-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_records                             = ["192.168.6.4"]
  private_dns_zone_virtual_network_link_name               = "pvtdnszonevnet-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_virtual_network_link_virtual_network_id = module.middletier-vnet.vnet_id
}

module "pep_servicebus" {
  source                                                   = "./private_endpoint"
  rg_name                                                  = var.rg_name
  location                                                 = var.location
  environment                                              = var.environment
  subnet_id                                                = module.middletier_pvtlnk_subnet.subnet_id
  private_endpoint_name                                    = "pep-sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  private_service_connection_name                          = "psc-sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  private_connection_resource_id                           = module.servicebus.servicebus_id
  subresource_names                                        = ["namespace"]
  private_dns_zone_group_name                              = "pvtdnszonegrp.sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_name                                    = "privatelink.sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_name                                = "sbns-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_records                             = ["192.168.6.5"]
  private_dns_zone_virtual_network_link_name               = "pvtdnszonevnet-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_virtual_network_link_virtual_network_id = module.middletier-vnet.vnet_id
}

module "pep_storageaccount" {
  source                                                   = "./private_endpoint"
  rg_name                                                  = var.rg_name
  location                                                 = var.location
  environment                                              = var.environment
  subnet_id                                                = module.middletier_pvtlnk_subnet.subnet_id
  private_endpoint_name                                    = "pep-st-${var.rg_name_code}-${var.environment}-${var.location}"
  private_service_connection_name                          = "psc-st-${var.rg_name_code}-${var.environment}-${var.location}"
  private_connection_resource_id                           = module.storageaccount.storageaccount_id
  subresource_names                                        = ["blob"]
  private_dns_zone_group_name                              = "pvtdnszonegrp.st-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_name                                    = "privatelink.st-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_name                                = "st-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_records                             = ["192.168.6.6"]
  private_dns_zone_virtual_network_link_name               = "pvtdnszonevnet-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_virtual_network_link_virtual_network_id = module.middletier-vnet.vnet_id
}

module "pep_sql" {
  source                                                   = "./private_endpoint"
  rg_name                                                  = var.rg_name
  location                                                 = var.location
  environment                                              = var.environment
  subnet_id                                                = module.middletier_pvtlnk_subnet.subnet_id
  private_endpoint_name                                    = "pep-sql-${var.rg_name_code}-${var.environment}-${var.location}"
  private_service_connection_name                          = "psc-sql-${var.rg_name_code}-${var.environment}-${var.location}"
  private_connection_resource_id                           = module.sql.sql_id
  subresource_names                                        = ["sqlServer"]
  private_dns_zone_group_name                              = "pvtdnszonegrp.sql-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_name                                    = "privatelink.sql-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_name                                = "sql-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_records                             = ["192.168.6.7"]
  private_dns_zone_virtual_network_link_name               = "pvtdnszonevnet-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_virtual_network_link_virtual_network_id = module.middletier-vnet.vnet_id
}

module "pep_cosnodb" {
  source                                                   = "./private_endpoint"
  rg_name                                                  = var.rg_name
  location                                                 = var.location
  environment                                              = var.environment
  subnet_id                                                = module.middletier_pvtlnk_subnet.subnet_id
  private_endpoint_name                                    = "pep-cosno-${var.rg_name_code}-${var.environment}-${var.location}"
  private_service_connection_name                          = "psc-cosno-${var.rg_name_code}-${var.environment}-${var.location}"
  private_connection_resource_id                           = module.cosnodb.cosnodb_id
  subresource_names                                        = ["Sql"]
  private_dns_zone_group_name                              = "pvtdnszonegrp.cosno-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_name                                    = "privatelink.cosno-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_name                                = "cosno-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_a_record_records                             = ["192.168.6.8"]
  private_dns_zone_virtual_network_link_name               = "pvtdnszonevnet-${var.rg_name_code}-${var.environment}-${var.location}"
  private_dns_zone_virtual_network_link_virtual_network_id = module.middletier-vnet.vnet_id
}

module "ds_keyvault" {
  #depends_on  = [module.keyvault, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.keyvault.kv_id
  law                     = module.loganalyticsworkspace.law_id
  diagnosticsettings_name = "kv-ds-${var.rg_name_code}-${var.environment}-${var.location}"
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
}

module "ds_apc" {
  depends_on              = [module.appconfiguration, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.appconfiguration.appconfigu_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
  diagnosticsettings_name = "appcss-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_aks_fe" {
  depends_on              = [module.aks_fe, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.aks_fe.aks_id
  law                     = module.loganalyticsworkspace.law_id
  diagnosticsettings_name = "aks-ds-${var.rg_name_code}-${var.environment}-${var.location}"
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
}

module "ds_aks_mt" {
  depends_on              = [module.aks_mt, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.aks_mt.aks_id
  law                     = module.loganalyticsworkspace.law_id
  diagnosticsettings_name = "aks-ds-${var.rg_name_code}-${var.environment}-${var.location}"
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
}


module "ds_afd" {
  depends_on              = [module.frontdoor, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.frontdoor.afd_id
  law                     = module.loganalyticsworkspace.law_id
  diagnosticsettings_name = "afd-ds-${var.rg_name_code}-${var.environment}-${var.location}"
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
}

module "ds_acr" {
  depends_on              = [module.acr, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.acr.acr_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["audit", "allLogs"]
  diagnosticsettings_name = "acr-ds-${var.rg_name_code}-${var.environment}-${var.location}"

}

module "ds_appi" {
  depends_on              = [module.appinsights, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.appinsights.appinsights_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs"]
  diagnosticsettings_name = "appi-ds-${var.rg_name_code}-${var.environment}-${var.location}"

}

module "ds_spoke-vnet" {
  depends_on              = [module.frontend-spoke-vnet, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.frontend-spoke-vnet.vnet_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs"]
  diagnosticsettings_name = "svnet-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_middletiervnet" {
  depends_on              = [module.middletier-vnet, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.middletier-vnet.vnet_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs"]
  diagnosticsettings_name = "mtvnet-ds-${var.rg_name_code}-${var.environment}-${var.location}"

}

# module "ds_hub-vnet" {
#   depends_on              = [module.hub-vnet, module.loganalyticsworkspace]
#   source                  = "./diagnosticsettings"
#   rg_name                 = var.rg_name
#   location                = var.location
#   environment             = var.environment
#   trgid                   = module.hub-vnet.vnet_id
#   law                     = module.loganalyticsworkspace.law_id
#   metrics                 = ["AllMetrics"]
#   logs                    = ["allLogs"]
#   diagnosticsettings_name = "hvnet-ds-${var.rg_name}-${var.environment}-${var.location}"

# }


module "ds_rediscache" {
  depends_on              = [module.rediscache, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.rediscache.rediscache_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs", "audit"]
  diagnosticsettings_name = "redis-ds-${var.rg_name_code}-${var.environment}-${var.location}"

}

module "ds_servicebus" {
  depends_on              = [module.servicebus, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.servicebus.servicebus_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs", "audit"]
  diagnosticsettings_name = "sbns-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_storageaccount" {
  depends_on      = [module.storageaccount, module.loganalyticsworkspace]
  source          = "./diagnosticsettings"
  rg_name         = var.rg_name
  location        = var.location
  environment     = var.environment
  trgid           = module.storageaccount.storageaccount_id
  law             = module.loganalyticsworkspace.law_id
  metrics         = ["Transaction"]
  metrics_enabled = true
  # logs        = ["allLogs", "audit"]
  diagnosticsettings_name = "st-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_cosnodb" {
  depends_on              = [module.cosnodb, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.cosnodb.cosnodb_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs", "audit"]
  diagnosticsettings_name = "cosnodb-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}


module "ds_sqldatabase" {
  depends_on              = [module.sqldatabase, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.sqldatabase.sql_database_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs", "audit"]
  diagnosticsettings_name = "sqldb-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}


module "ds_apim" {
  depends_on              = [module.apim, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.apim.apim_id
  law                     = module.loganalyticsworkspace.law_id
  metrics                 = ["AllMetrics"]
  metrics_enabled         = true
  logs                    = ["allLogs", "audit"]
  diagnosticsettings_name = "apim-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_nsg-spokesubnet" {
  depends_on              = [module.nsg-spokesubnet, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings_nsg"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.nsg-spokesubnet.nsg_id
  law                     = module.loganalyticsworkspace.law_id
  logs                    = ["allLogs"]
  diagnosticsettings_name = "nsg-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_nsg-middletier_akssubnet" {
  depends_on              = [module.nsg-middletier_akssubnet, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings_nsg"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.nsg-middletier_akssubnet.nsg_id
  law                     = module.loganalyticsworkspace.law_id
  logs                    = ["allLogs"]
  diagnosticsettings_name = "nsg-ask-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}

module "ds_nsg-middletier_apimsubnet" {
  depends_on              = [module.nsg-middletier_apimsubnet, module.loganalyticsworkspace]
  source                  = "./diagnosticsettings_nsg"
  rg_name                 = var.rg_name
  location                = var.location
  environment             = var.environment
  trgid                   = module.nsg-middletier_apimsubnet.nsg_id
  law                     = module.loganalyticsworkspace.law_id
  logs                    = ["allLogs"]
  diagnosticsettings_name = "nsg-apim-ds-${var.rg_name_code}-${var.environment}-${var.location}"
}
