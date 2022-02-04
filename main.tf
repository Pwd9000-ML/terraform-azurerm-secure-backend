##################################################
# DATA                                           #
##################################################
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

##################################################
# RESOURCES                                      #
##################################################

resource "azurerm_resource_group" "backend_rg" {
  name     = var.backend_resource_group_name
  location = var.location
  tags     = merge(var.common_tags, { Purpose = "Terraform-Backend-Resource-Group-${var.environment}" })
}

resource "azurerm_resource_group" "primary_rg" {
  name     = var.primary_resource_group_name
  location = var.location
  tags     = merge(var.common_tags, { Purpose = "Terraform-Primary-Resource-Group-${var.environment}" })
}

#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "backend_sa" {
  name                      = var.backend_storage_account_name
  resource_group_name       = azurerm_resource_group.backend_rg.name
  location                  = azurerm_resource_group.backend_rg.location
  access_tier               = var.backend_sa_access_tier
  account_kind              = var.backend_sa_account_kind
  account_tier              = var.backend_sa_account_tier
  account_replication_type  = var.backend_sa_account_repl
  enable_https_traffic_only = var.backend_sa_account_https
  min_tls_version           = "TLS1_2"
  tags                      = merge(var.common_tags, { Purpose = "Backend-State-Storage-${var.environment}" })
}

resource "azurerm_storage_container" "backend_sa_container" {
  name                 = "backend-remote-state"
  storage_account_name = azurerm_storage_account.backend_sa.name
}

resource "azurerm_storage_container" "primary_sa_container" {
  name                 = "primary-remote-state"
  storage_account_name = azurerm_storage_account.backend_sa.name
}

#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "backend_kv" {
  name                            = var.kv_name
  location                        = azurerm_resource_group.backend_rg.location
  resource_group_name             = azurerm_resource_group.backend_rg.name
  tenant_id                       = data.azurerm_subscription.current.tenant_id
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enabled_for_deployment          = true
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  sku_name                        = "standard"
  tags                            = merge(var.common_tags, { Purpose = "Backend-Key-Vault-${var.environment}" })

  access_policy {
    tenant_id       = data.azurerm_subscription.current.tenant_id
    object_id       = azuread_service_principal.terraform_app_sp.id
    key_permissions = []
    secret_permissions = [
      "get",
      "list",
    ]
    certificate_permissions = []
    storage_permissions     = []
  }

  access_policy {
    tenant_id       = data.azurerm_subscription.current.tenant_id
    object_id       = data.azurerm_client_config.current.object_id
    key_permissions = []
    secret_permissions = [
      "backup",
      "delete",
      "purge",
      "recover",
      "restore",
      "set",
      "get",
      "list",
    ]
    certificate_permissions = []
    storage_permissions     = []
  }
}

resource "azuread_application" "terraform_app" {
  display_name = "terraform-SPN"
}

resource "azuread_service_principal" "terraform_app_sp" {
  application_id = azuread_application.terraform_app.application_id
}

resource "azuread_service_principal_password" "terraform_app_sp_pwd" {
  service_principal_id = azuread_service_principal.terraform_app_sp.id
}

resource "azurerm_role_definition" "terraform_role" {
  name        = "terraform-contributor"
  scope       = data.azurerm_subscription.current.id
  description = "Allow terraform SP to manage everything except security access and Blueprint actions."
  permissions {
    actions     = ["*"]
    not_actions = ["Microsoft.Authorization/*/Delete", "Microsoft.Authorization/*/Write", "Microsoft.Authorization/elevateAccess/Action", "Microsoft.Blueprint/*/write", "Microsoft.Blueprint/*/delete"]
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "primary_rg_ra" {
  scope = azurerm_resource_group.primary_rg.id
  #role_definition_id = azurerm_role_definition.terraform_role.id <Broken GH ticket>
  role_definition_name = azurerm_role_definition.terraform_role.name # temp work around
  principal_id         = azuread_service_principal.terraform_app_sp.id
}

resource "azurerm_role_assignment" "primary_sa_container_ra" {
  scope                = "${azurerm_resource_group.backend_rg.id}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.backend_sa.name}/blobServices/default/containers/${azurerm_storage_container.primary_sa_container.name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.terraform_app_sp.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "terraform_client_id" {
  name         = "tf-arm-client-id"
  value        = azuread_application.terraform_app.application_id
  key_vault_id = azurerm_key_vault.backend_kv.id
  tags         = merge(var.common_tags, { Purpose = "Terraform-Service-Principal-Application-ID" })
  content_type = "ARM_CLIENT_ID"
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "terraform_client_secret" {
  name         = "tf-arm-client-secret"
  value        = azuread_service_principal_password.terraform_app_sp_pwd.value
  key_vault_id = azurerm_key_vault.backend_kv.id
  tags         = merge(var.common_tags, { Purpose = "Terraform-Service-Principal-Application-Secret" })
  content_type = "ARM_CLIENT_SECRET"
}

resource "null_resource" "setup-log" {
  provisioner "local-exec" {
    command     = <<EOT
$user = az account show | ConvertFrom-Json
$username = $user.user.name
$subscription = $user.name
$subscriptionID = $user.id
$date = get-date
Add-content -value 'Initial setup performed by:' -Path "setup.log"
Add-content -value "Date: $date" -Path "setup.log"
Add-content -value "User: $username" -Path "setup.log"
Add-content -value "Subscription: $subscription" -Path "setup.log"
Add-content -value "SubscriptionID: $subscriptionID" -Path "setup.log"
Add-content -value '' -Path "setup.log"
Add-content -value 'Setup Information:' -Path "setup.log"
Add-content -value 'Backend Resource Group Name = "${azurerm_resource_group.backend_rg.name}"' -Path "setup.log"
Add-content -value 'Backend Storage Account Name = "${azurerm_storage_account.backend_sa.name}"' -Path "setup.log"
Add-content -value 'Backend Remote State Container Name = "${azurerm_storage_container.backend_sa_container.name}"' -Path "setup.log"
Add-content -value 'Primary Remote State Container Name = "${azurerm_storage_container.primary_sa_container.name}"' -Path "setup.log"
Add-content -value 'Backend Key Vault Name = "${azurerm_key_vault.backend_kv.name}"' -Path "setup.log"
Add-content -value 'Backend Key Vault ID = "${azurerm_key_vault.backend_kv.id}"' -Path "setup.log"
Add-content -value 'Primary Resource Group Name = "${azurerm_resource_group.primary_rg.name}"' -Path "setup.log"
Add-content -value 'Terraform Service Principal Application ID = "${azuread_application.terraform_app.application_id}"' -Path "setup.log"
Add-content -value 'Terraform Service Principal Object ID = "${azuread_application.terraform_app.id}"' -Path "setup.log"
Add-content -value 'Terraform Contributor Role Definition = "${azurerm_role_definition.terraform_role.name}"' -Path "setup.log"
Add-content -value 'Terraform app and role assigned to: "${azurerm_resource_group.primary_rg.name}"' -Path "setup.log"
Add-content -value 'Terraform app ID secret: "${azurerm_key_vault_secret.terraform_client_secret.name}" can be obtained from kv: "${azurerm_key_vault.backend_kv.name}"' -Path "setup.log"
EOT
    interpreter = ["Powershell", "-Command"]
  }
}
