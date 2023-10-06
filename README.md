[![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

# Module: Secure Backend

## Description

This module can be used to provision a `primary terraform resource group` and a `backend terraform resource group`.  
The primary resource group will be assigned with a service principal that is linked with a custom rbac role: `terraform-contributor`. The primary resource group can then be utilized with the azureRM provider by a remote team using the provided service principal to build future projects or solutions within the `Primary resource group`.  
  
The `backend resource group` will not be associated with the newly created `terraform-SPN` AAD Application & service principal created by this module.  
The `backend resource group` will contain a backend storage account and two containers named: `backend-state` and `primary-state` for storing remote states.  
Storage containers are kept separated to keep the `backend state` separate from the `primary state` as the `primary state` will be utilized by the remote team using the principal created by this module. The provided `terraform-SPN` AAD Application & service principal will only have access to the backend storage account container `primary-state` to access the remote state of future deployments by the remote teams terraform deployments.  
  
The `backend resource group` will also contain a `backend key vault` where the `terraform-SPN` AAD Application service principal ID and secret will be stored as secrets that can be given to the remote team to configure their provider with.  

The `terraform-SPN` service principal will also only have access to get and list keys from the `backend key vault`.  
The admin user who sets up the environment using this module will have full access to the backend key vault and can distribute the details to the remote team.  
  
This `secure backend module` should be created by a privileged admin user who has sufficient access to the subscription.  
After the backend and primary resources have been created the admin can migrate the backend state to the provided storage account container if required and pass on the details of the `terraform-SPN` service principal to a team who will use Terraform to configure their azureRM provider to start using the `primary resource group` for their deployments.  
The teams azureRM provider they configure with the provided service principal, will only have access to the backend storage container `primary-state` to store state files for deployments made in the `primary resource group`.  
The provided service principal will have `contributor` rights to only the `Primary resource group` and not the backend resource group.  
The provided service principal will also only have access to get and list keys from the `backend key vault`.  
  
## Module summary (performed by admin)
  
- Create Primary resource group.
- Create Backend resource group.
- Create Backend storage account:
  - Create container: `backend-state`, where admin can migrate this module terraform state.
  - Create container: `primary-state`, where "terraform-SPN" service principal can migrate future projects terraform state.
- Create the custom role definition  
  - assigned to the primary resource group with `terraform-contributor`.
  - assigned to backend storage account container: `primary-state` (Storage Blob Data Contributor).
- Create `terraform-SPN` AAD Application & service principal with the `terraform-contributor` custom role definition assigned to use in the azureRM provider.
- Create Backend terraform key vault to home created `terraform` Service principal ID and Secret:
  - The service principal ARM_CLIENT_ID: `tf-arm-client-id` and ARM_CLIENT_SECRET: `tf-arm-client-secret` will be stored in the created backend key vault.
  - Assign access policy to key vault for `terraform-SPN` service principal (Get/List)

A setup log (setup.log) is also generated as part of the initial deployment.  
State files are kept in separate storage containers so that terraform destroy does not destroy the backend.  
Anyone who utilise the Primary resource group for terraform deployments, using the service principal: `terraform-SPN` provisioned by this module can thus store state inside of the `primary-state` container which the `terraform-SPN` principal will have access to.
  
## Usage
  
The initial setup needs to be performed by an admin user who has sufficient permissions to Azure via CLI. (See examples readme for more info)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |

## Providers

| Name | Version |
|------|---------|

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.terraform_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.terraform_app_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.terraform_app_sp_pwd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [azurerm_key_vault.backend_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.terraform_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.terraform_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_resource_group.backend_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.primary_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.primary_rg_ra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.primary_sa_container_ra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.terraform_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_storage_account.backend_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.backend_sa_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.primary_sa_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [null_resource.setup-log](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_resource_group_name"></a> [backend\_resource\_group\_name](#input\_backend\_resource\_group\_name) | The name for the backend resource group that will home the backend storage account and backend key vault. (Default: BackendRG) | `string` | `"BackendRG"` | no |
| <a name="input_backend_sa_access_tier"></a> [backend\_sa\_access\_tier](#input\_backend\_sa\_access\_tier) | The access tier of the backend storage account. (accepted values: Cool, Hot) | `string` | `"Hot"` | no |
| <a name="input_backend_sa_account_https"></a> [backend\_sa\_account\_https](#input\_backend\_sa\_account\_https) | Boolean flag which forces HTTPS if enabled. (accepted values: true, false) | `bool` | `true` | no |
| <a name="input_backend_sa_account_kind"></a> [backend\_sa\_account\_kind](#input\_backend\_sa\_account\_kind) | Defines the Kind of account. (accepted values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2) | `string` | `"BlobStorage"` | no |
| <a name="input_backend_sa_account_repl"></a> [backend\_sa\_account\_repl](#input\_backend\_sa\_account\_repl) | Defines the type of replication to use for this storage account. (accepted values: LRS, GRS, RAGRS, ZRS) | `string` | `"LRS"` | no |
| <a name="input_backend_sa_account_tier"></a> [backend\_sa\_account\_tier](#input\_backend\_sa\_account\_tier) | Defines the Tier to use for this storage account. (accepted values: Standard, Premium. For FileStorage accounts only Premium is valid.) | `string` | `"Standard"` | no |
| <a name="input_backend_storage_account_name"></a> [backend\_storage\_account\_name](#input\_backend\_storage\_account\_name) | The name for the backend storage account that will home the backend and primary state blob containers. (Unique all lowercase) | `string` | `"tfbackendsa"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of key value pairs that is used to tag resources created. (Default: demo map) | `map(string)` | <pre>{<br>  "CommonTag1": "demo1",<br>  "CommonTag2": "This is a demo"<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Value to describe the environment. Primarily used for tagging and naming resources. (Default: Development) | `string` | `"Development"` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name for the backend key vault that will home terraform secrets e.g. terraform ARM\_CLIENT\_ID and ARM\_CLIENT\_SECRET. (Unique all lowercase) | `string` | `"terraform-kv"` | no |
| <a name="input_kv_sku"></a> [kv\_sku](#input\_kv\_sku) | Key Vault SKU. (Default: standard) | `string` | `"standard"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location in azure where resources will be created. (Default: uksouth) | `string` | `"uksouth"` | no |
| <a name="input_primary_resource_group_name"></a> [primary\_resource\_group\_name](#input\_primary\_resource\_group\_name) | The name for the primary resource group with 'terraform-contributor' role assigned. (Default: BackendRG) | `string` | `"PrimaryRG"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Key Vault soft delete retention days. (Default: 7) | `number` | `"7"` | no |
| <a name="input_spn_name"></a> [spn\_name](#input\_spn\_name) | Azure AD App & SPN name. (Default: terraform-SPN) | `string` | `"terraform-SPN"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_key_vault_id"></a> [backend\_key\_vault\_id](#output\_backend\_key\_vault\_id) | The resource ID for the backend key vault. |
| <a name="output_backend_resource_group_id"></a> [backend\_resource\_group\_id](#output\_backend\_resource\_group\_id) | The resource ID for the backend resource group. |
| <a name="output_backend_storage_account_id"></a> [backend\_storage\_account\_id](#output\_backend\_storage\_account\_id) | The resource ID for the backend storage account. |
| <a name="output_primary_resource_group_id"></a> [primary\_resource\_group\_id](#output\_primary\_resource\_group\_id) | The resource ID for the primary resource group. |
| <a name="output_terraform_application_id"></a> [terraform\_application\_id](#output\_terraform\_application\_id) | The CLIENT ID for the terraform application service principal. |
| <a name="output_terraform_custom_role_id"></a> [terraform\_custom\_role\_id](#output\_terraform\_custom\_role\_id) | The terraform-contributor role id. |
<!-- END_TF_DOCS -->