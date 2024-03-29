# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed

locals {
  private_dns_zones_names = var.environment == "public" ? [
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.monitor.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.oms.opinsights.azure.com",
    ] : [
    "privatelink.oms.opinsights.azure.us",
    "privatelink.ods.opinsights.azure.us",
    "privatelink.agentsvc.azure-automation.us",
    "privatelink.blob.core.usgovcloudapi.net",
    "privatelink.blob.core.usgovcloudapi.net",
  ]
}
