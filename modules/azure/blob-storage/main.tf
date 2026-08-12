resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type

  # Secure by default
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  blob_properties {
    delete_retention_policy { days = 30 }
    container_delete_retention_policy { days = 30 }
    versioning_enabled = true
  }

  tags = merge(var.tags, { ManagedBy = "terraform-module-registry" })
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

variable "storage_account_name" { type = string }
variable "container_name"       { type = string; default = "data" }
variable "resource_group_name"  { type = string }
variable "location"             { type = string; default = "East US" }
variable "replication_type"     { type = string; default = "GRS" }
variable "tags"                 { type = map(string); default = {} }

output "storage_account_id"   { value = azurerm_storage_account.this.id }
output "primary_blob_endpoint" { value = azurerm_storage_account.this.primary_blob_endpoint }
