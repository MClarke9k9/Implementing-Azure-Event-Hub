data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "random_string" "storage_suffix" {
  length  = 5
  special = false
  upper   = false
}

# ----------------------------
# Event Hub Namespace
# ----------------------------

resource "azurerm_eventhub_namespace" "namespace" {
  name                = "namespace-${var.name_suffix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku           = "Standard"
  capacity      = 2
  auto_inflate_enabled = false
}

# ----------------------------
# Storage Account
# ----------------------------

resource "azurerm_storage_account" "storage" {
  name                     = "storage${random_string.storage_suffix.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true

  min_tls_version = "TLS1_2"
}

# ----------------------------
# Blob Container
# ----------------------------

resource "azurerm_storage_container" "events" {
  name                  = "events"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"
}

# ----------------------------
# Event Hub
# ----------------------------

resource "azurerm_eventhub" "events" {
  name                = "events"
  namespace_id        = azurerm_eventhub_namespace.namespace.id
  partition_count     = 2
  message_retention   = 1

  capture_description {
    enabled  = true
    encoding = "Avro"

    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = azurerm_storage_container.events.name
      storage_account_id  = azurerm_storage_account.storage.id
    }
  }
}

# ----------------------------
# Shared Access Policy
# ----------------------------

resource "azurerm_eventhub_namespace_authorization_rule" "root" {
  name                = "terraform-policy"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = data.azurerm_resource_group.rg.name

  listen = true
  send   = true
  manage = true
}