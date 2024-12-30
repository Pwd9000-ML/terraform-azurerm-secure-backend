##################################################
# OUTPUTS                                        #
##################################################
output "backend_resource_group_id" {
  value       = azurerm_resource_group.backend_rg.id
  description = "The resource ID for the backend resource group."
}

output "primary_resource_group_id" {
  value       = azurerm_resource_group.primary_rg.id
  description = "The resource ID for the primary resource group."
}

output "backend_storage_account_id" {
  value       = azurerm_storage_account.backend_sa.id
  description = "The resource ID for the backend storage account."
}

output "backend_key_vault_id" {
  value       = azurerm_key_vault.backend_kv.id
  description = "The resource ID for the backend key vault."
}

output "terraform_application_id" {
  value       = azuread_application.terraform_app.client_id
  description = "The CLIENT ID for the terraform application service principal."
}

output "terraform_custom_role_id" {
  value       = azurerm_role_definition.terraform_role.id
  description = "The terraform-contributor role id."
}