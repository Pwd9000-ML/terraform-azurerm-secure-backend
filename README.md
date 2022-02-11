[![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml)

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
  
## Providers and terraform version requirements
  
- terraform version >= 1.1.4
- provider "azuread" >= 2.17.0
- provider "azurerm" >= 2.95.0
  
## Module Input variables
  
- `backend_storage_account_name` - (Required) Specifies the name of the Backend Storage Account (must be unique, all lowercase).
- `kv_name` - (Required) Specifies the name of the Backend Key Vault (must be unique).
- `soft_delete_retention_days` - (Optional) - Key Vault soft delete retention days. (Default: 7).
- `kv_sku` - (Optional) - Key Vault SKU. (Default: standard).
- `backend_resource_group_name` - (Optional) Specifies the name of the Backend Resource Group.
- `backend_sa_access_tier` - (Optional) The access tier of the backend storage account. (accepted values: Cool, Hot).
- `backend_sa_account_kind` - (Optional) Defines the Kind of account. (accepted values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2).
- `backend_sa_account_tier` - (Optional) Defines the Tier to use for this storage account. (accepted values: Standard, Premium. For FileStorage accounts only Premium is valid.).
- `backend_sa_account_repl` - (Optional) Defines the type of replication to use for this storage account. (accepted values: LRS, GRS, RAGRS, ZRS).
- `backend_sa_account_https` - (Optional) Boolean flag which forces HTTPS if enabled. (accepted values: true, false)
- `common_tags` - (Optional) Optional map of strings to use as tags on resources.
- `environment` - (Optional) Specifies the name of the environment (e.g. Development).
- `location` - (Optional) Specifies the location of resources (e.g. uksouth).
- `primary_resource_group_name` - (Optional) Specifies the name of the Primary Resource Group.
- `spn_name` - (Optional) - Azure AD App & SPN name. (Default: terraform-SPN).
  
## Module Outputs

- `backend_resource_group_id` - The resource ID for the backend resource group.
- `primary_resource_group_id` -  The resource ID for the primary resource group.
- `backend_storage_account_id` - The resource ID for the backend storage account.
- `backend_key_vault_id` - The resource ID for the backend key vault.
- `terraform_application_id` - The CLIENT ID for the terraform application service principal.
- `terraform_custom_role_id` - The terraform-contributor role id.

## Other requirements

- Azure CLI version >= 2.32.0

## Example

An example .tf and .tfvars file can be found under path Examples/backend along with a readme.md.  
