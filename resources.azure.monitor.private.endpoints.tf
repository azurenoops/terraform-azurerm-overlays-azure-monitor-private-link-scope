# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Private Link Endpoints for Azure Monitor 
#---------------------------------------------------------
resource "azurerm_private_endpoint" "ampls" {  
  name                = local.private_endpoint_name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = data.azurerm_subnet.ampls_subnet.id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = azurerm_private_dns_zone.main.*.id
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

resource "azurerm_private_dns_zone" "main" {
  count               = length(local.private_dns_zones_names)
  name                = element(local.private_dns_zones_names, count.index)
  resource_group_name = local.resource_group_name
}

