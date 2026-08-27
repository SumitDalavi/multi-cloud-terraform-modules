resource "azurerm_cosmosdb_account" "this" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "geo_location" {
    for_each = var.failover_location != null ? [1] : []
    content {
      location          = var.failover_location
      failover_priority = 1
    }
  }

  is_virtual_network_filter_enabled = true
  public_network_access_enabled     = false

  tags = merge(var.tags, { ManagedBy = "terraform-module-registry" })
}

variable "account_name" { type = string }
variable "location" {
  type    = string
  default = "East US"
}
variable "resource_group_name" { type = string }
variable "consistency_level" {
  type    = string
  default = "Session"
}
variable "failover_location" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

output "endpoint" { value = azurerm_cosmosdb_account.this.endpoint }
output "primary_key" {
  value     = azurerm_cosmosdb_account.this.primary_key
  sensitive = true
}
