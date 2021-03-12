# Module: Secure Backend

## Description

This module can be used to provision a `primary terraform resource group` and a `backend terraform resource group`.  
The primary resource group will be assigned with a service principal that is linked with a custom rbac role: `terraform-contributor`. The Primary resource group can then be utilised with the azurerm provider by a team using the provided service principal to build future projects or solutions within the `Primary resource group`.  
  
The `backend resource group` will not be associated with thenew ly created `terraform` service principal provided by this module.  
The `backend resource group` will contain a backend storage account and two containers named: `backend-state` and `primary-state` for storing remote states.  
Containers are kept seperated to keep the `backend state` seperate from the `primary state` as the primary state will be utilised by another team or someone else using the provided Service Principal. The provided `terraform` service principal will only have access to the backend storage account container `primary-state` to access the remote state of future deployments by the remote teams terraform deployments.  
  
The `backend resource group` will also contain a `backend key vault` where the "terraform" service principal ID and secret will be stored as secrets.  
The "terraform" service principal will also only have access to get and list keys in the backend key vault.  
The admin user who sets up the environment using this module will have full access to the backend key vault and can distribute the details to a team.  
  
This backend module should be created by a priviliged admin user who has sufficient access to the subscription.  
After the backend and primary resources have been created the admin can migrate the backend state to the provided storage account container (backend-state)  
and pass on the details of the "terraform" service principal to a team who will use Terraform to configure their azurerm provider.  
The teams azurerm provider they configure with the provided service principal, will only have access to the backend storage container `primary-state` to store state files for deployments made in the `primary resource group`.  
The provided service principal will have `contributor` rights to only the `Primary resource group` and not the backend resource group.  
The provided service principal will also only have access to get and list keys from the `backend key vault`.  
  
## Module summary (performed by admin)
  
- Create Primary resource group.
- Create Backend resource group.
- Create Backend storage account:
  - Create container: `backend-state`, where admin can migrate this module terraform state.
  - Create container: `primary-state`, where "terraform" service principal can migrate future projects terraform state.
- Create the custom role definition  
  - assigned to the primary resource group with rele `terraform-contributor`.
  - assigned to backend storage account container: `primary-state` (Storage Blob Data Contributor).
- Create `terraform` service principal with the `terraform-contributor` custom role definition assigned to use in the azurerm provider.
- Create Backend terraform key vault to home created `terraform` Service principal ID and Secret:
  - The service principal CLIENT_ID: `tf-arm-client-id` and CLIENT_SECRET: `tf-arm-client-secret` will be stored in the backend keyvault created.
  - Assign access policy to keyvault for `terraform` service principal (Get/List)

A setup log (setup.log) is also generated as part of the initial deployment.  
State files are kept in seperate storage containers so that terraform destroy does not destroy the backend.  
Anyone who utilises the Primary resource group for terraform deployments, using the service principal: `terraform` provisioned by this module can thus store state inside of the `primary-state` container which the `terraform` principal will have access to.
  
## Usage
  
The initial setup needs to be performed by an admin user who has sufficient permissions to Azure via CLI. (See examples readme for more info)  
  
## Providers and terraform version requirements
  
- terraform version >= 0.14.0
- provider "azuread" >= 1.0.0
- provider "azurerm" >= 2.41.0
  
## Module Input variables
  
- backend_storage_account_name - (Required) Specifies the name of the Backend Storage Account (must be unique, all lowercase).
- kv_name - (Required) Specifies the name of the Backend Key Vault (must be unique).
- backend_resource_group_name - (Optional) Specifies the name of the Backend Resource Group.
- backend_sa_access_tier - (Optional) The access tier of the backend storage account. (accepted values: Cool, Hot)
- backend_sa_account_kind - (Optional) Defines the Kind of account. (accepted values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2)
- backend_sa_account_tier - (Optional) Defines the Tier to use for this storage account. (accepted values: Standard, Premium. For FileStorage accounts only Premium is valid.)
- backend_sa_account_repl - (Optional) Defines the type of replication to use for this storage account. (accepted values: LRS, GRS, RAGRS, ZRS)
- backend_sa_account_https - (Optional) Boolean flag which forces HTTPS if enabled. (accepted values: true, false)
- common_tags - (Optional) Optional map of strings to use as tags on resources.
- environment - (Optional) Specifies the name of the environment (e.g. Development).
- location - (Optional) Specifies the location of resources (e.g. westeurope).
- primary_resource_group_name - (Optional) Specifies the name of the Primary Resource Group.
  
## Module Outputs

- backend_resource_group_id - The resource ID for the backend resource group.
- primary_resource_group_id -  The resource ID for the primary resource group.
- backend_storage_account_id - The resource ID for the backend storage account.
- backend_key_vault_id - The resource ID for the backend key vault.
- terraform_application_id - The CLIENT ID for the terraform application service principal.
- terraform_custom_role_id - The terraform-contributor role id.

## Other requirements

- Azure CLI version >= 2.0.0
- Powershell version >= 5.1

## Example

An example .tf and .tfvars file can be found under path Examples/backend along with a readme.md.  
