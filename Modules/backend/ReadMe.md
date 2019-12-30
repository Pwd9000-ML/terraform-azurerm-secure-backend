# Module Backend

## Description

This module can be used to provision a primary terraform resource group and a backend terraform resource group.  
The primary resource group will be assigned with a "terraform" service principal that is linked with a custom rbac role (terraform-contributor).  
The Primary resource group can then be utilised with the terraform azurerm provider by someone else using the provided service principal to build future projects  
or POCs within the Primary resource group.  
  
The backend resource group will not be assigned with the "terraform" service principal.  
The backend resource group will contain a backend storage account and two containers (backend-state/primary-state) for storing remote states.  
Containers are seperated to keep the "backend state" seperate from the "primary state" as the primary state will be utilised by someone else using the provided SP.  
The provided "terraform" service principal will only have access to the backend storage account container (primary-state) to access the remote state of future projects.  
  
The backend resource group will also contain a backend key vault where the "terraform" service principal ID and secret will be stored as secrets.  
The "terraform" service principal will also only have access to get and list keys in the backend key vault.  
The admin user who sets up the environment using this module will have full access to the backend key vault.  
  
This backend module should be created by a priviliged admin user who has sufficient access to the subscription.  
After the backend and primary resources have been created the admin can migrate the backend state to the provided storage account container (backend-state)  
and pass on the details of the "terraform" service principal to a team who will use Terraform to configure their azurerm provider.  
This provider will only have access to the backend storage container (primary-state) for remote state of infrastructure built in the Primary resource group.  
The provider will have contributor rights to only the Primary resource group and not the backend resource group.  
The provider will only have access to get keys from the backend key vault.  
  
## Module summary (performed by admin)
  
- Create Primary resource group.
- Create Backend resource group.
- Create Backend storage account:
  - Create container: backend-state, where admin can migrate this module terraform state.
  - Create container: primary-state, where "terraform" service principal can migrate future projects terraform state.
- Create the custom role definition  
  - assigned to the primary resource group (terraform-contributor).
  - assigned to backend storage account container: primary-state (Storage Blob Data Contributor).
- Create "terraform" service principal with the terraform-contributor role assigned to use in the azurerm provider.
- Create Backend terraform key vault to home created "terraform" Service principal ID and Secret:
  - The service principal CLIENT_ID ("tf-arm-client-id") and CLIENT_SECRET ("tf-arm-client-secret") will be stored in the backend keyvault created.
  - Assign access policy to keyvault for "terraform" service principal (Get/List)
  
There is also a #helpers section in resources.tf to enable soft delete on the backend keyvault if needed. Change property enableSoftDelete=true  
A setup log (setup.log) is also generated as part of the initial deployment.  
State files are kept seperate so that terraform destroy does not destroy the backend.  
  
## Usage
  
The initial setup needs to be performed by an admin user who has sufficient permissions to Azure via CLI. (See examples readme for more info)  
  
## Providers and terraform version requirements
  
- terraform version >= 0.12.0
- provider "azuread" >= 0.6.0
- provider "azurerm" >= 0.6.0
  
## Module Input variables
  
- backend_storage_account_name - (Required) Specifies the name of the Backend Storage Account (must be unique, all lowercase).
- kv_name - (Required) Specifies the name of the Backend Key Vault (must be unique).
- backend_resource_group_name - (Optional) Specifies the name of the Backend Resource Group.
- common_tags - (Optional) Optional map of strings to use as tags on resources.
- environment - (Optional) Specifies the name of the environment (e.g. Development).
- lob - (Optional) Specifies the Line Of Business (e.g. IT).
- location - (Optional) Specifies the location of resources (e.g. westeurope).
- primary_resource_group_name - (Optional) Specifies the name of the Primary Resource Group.
- region - (Optional) Specifies the region of resources (e.g. EMEA).
  
## Module Outputs

- backend_storage_account_id - The resource ID for the backend storage account.  
- backend_key_vault_id - The resource ID for the backend key vault.  
- terraform_application_id - The CLIENT ID for the terraform application service principal.  
- terraform_custom_role_id - The terraform-contributor role id.  

## Other requirements

- Azure CLI version >= 2.0.0
- Powershell version >= 5.1

## Example

An example .tf and .tfvars file can be found under path Examples/backend along with a readme.md.  
