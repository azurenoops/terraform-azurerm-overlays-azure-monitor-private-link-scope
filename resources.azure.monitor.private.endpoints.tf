# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Private Link Endpoints for Azure Monitor
#---------------------------------------------------------
resource "azurerm_private_endpoint" "ampls" {
  name                = local.private_endpoint_name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.existing_ampls_private_subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = local.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = var.azurerm_monitor_private_link_scope_id == null ? join("", azurerm_monitor_private_link_scope.main.*.id) : var.azurerm_monitor_private_link_scope_id
    subresource_names              = ["azuremonitor"]
  }
}

# --------------------------------------------------------------------------------------------------
# Private DNS Zones
# --------------------------------------------------------------------------------------------------

module "mod_pdz" {
  source  = "azurenoops/overlays-private-dns-zone/azurerm"
  version = "~> 1.0"
  count   = length(local.private_dns_zones_names)

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = var.workload_name

  private_dns_zone_name        = element(local.private_dns_zones_names, count.index)
  existing_resource_group_name = local.resource_group_name
  private_dns_zone_vnets_ids = [
    var.existing_ampls_virtual_network_id
  ]
/*
  # Private DNS Zone Record Set details
  soa_record_private_dns = [
    {
      email        = "azureprivatedns-host.microsoft.com"
      refresh_time = 3600
      retry_time   = 300
      expire_time  = 2419200
      minimum_ttl  = 10
      ttl          = 300
    }
  ] */

  add_tags = merge({ "ResourceName" = format("privatednszone%s", lower(replace(element(local.private_dns_zones_names, count.index), "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}

