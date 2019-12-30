# Terraform Example - Backend

## Description

The following example files can be used to demo the module called backend under path Modules/backend.
The example contains one terraform file (backend-demo.tf) and .tfvars file (terraform-demo.tfvars)
The backend-demo.tf file can be run to create a secure terraform environment backend as described in the module readme.

## Usage

1. Clone or copy the two files in this path to a local directory and open a command prompt.
2. amend the .tf file and .tfvars file with desired variables.
3. Log into azure using CLI "az login".
4. run: Terraform init ()
5. run: Terraform 

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
