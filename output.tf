output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "eventhub_name" {
  value = azurerm_eventhub.events.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "container_name" {
  value = azurerm_storage_container.events.name
}

output "primary_connection_string" {
  value     = azurerm_eventhub_namespace_authorization_rule.root.primary_connection_string
  sensitive = true
}

output "primary_key" {
  value     = azurerm_eventhub_namespace_authorization_rule.root.primary_key
  sensitive = true
}