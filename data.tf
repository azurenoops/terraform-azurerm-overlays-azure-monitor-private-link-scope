# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "ampls_vnet" {
  count               = var.existing_ampls_virtual_network_name == null ? 0 : 1
  name                = var.existing_ampls_virtual_network_name
  resource_group_name = var.existing_ampls_network_resource_group_name == "" ? local.resource_group_name : var.existing_ampls_network_resource_group_name
}

data "azurerm_subnet" "ampls_subnet" {
  count                = var.existing_ampls_private_subnet_name == null ? 0 : 1
  name                 = var.existing_ampls_private_subnet_name
  virtual_network_name = var.existing_ampls_virtual_network_name
  resource_group_name  = var.existing_ampls_network_resource_group_name == "" ? local.resource_group_name : var.existing_ampls_network_resource_group_name
}
