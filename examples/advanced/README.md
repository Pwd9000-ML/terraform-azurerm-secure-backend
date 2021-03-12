# Terraform Advanced Example - Backend

## Description

This example is the same as the simple example, but uses more advanced inputs and logic with the deployment and variables.  
The following example files can be used to demo the module called backend under path Modules/backend.  
The example contains:  

- main terraform file (main.tf)
- backend terraform file (backend.tf)
- .tfvars file (terraform.tfvars)  

The main.tf and terraform.tfvars files can be amended to create a secure terraform environment backend as described in the module readme.  
Amend terraform.tfvars with relevant SubscriptionID and TenantID that will be used with the azuread and azurerm provider.  
Amend backend.tf to migrate state to remote state.  

## Usage

1. Clone or copy the two files in this path to a local directory and open a command prompt.
2. Amend the .tf file and .tfvars file with desired variables.
3. Log into azure using CLI "az login".
4. run: Terraform init
5. BUILD:
---
terraform init
terraform plan -out deploy.tfplan
terraform apply deploy.tfplan

6. DESTROY:
---
terraform plan -destroy -out destroy.tfplan
terraform apply destroy.tfplan

## Migrating the backend statefile

After the backend infrastructure is setup from steps above (1-6):  

- Uncomment relevant lines from backend.tf and provide values for:
  - resource_group_name = "" (backend resource group name. This value will also be in "setup.log")
  - storage_account_name = "" (backend storage account name. This value will also be in "setup.log")
  - container_name = "backend-remote-state"
  - key = "terraform.tfstate"
- Run: Terraform init
- Delete any local .tfstate or .tfstate.backup files as these may contain sensitive information.

The backend state is now migrated to the backend storage account and container for the backend.  
To cleanup the demo run: terraform destroy and delete the .terraform directory. (contains remote backend state config).  

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
- backend_sa_account_blob_encrypt - (Optional) Boolean flag which controls if Encryption Services are enabled for Blob storage. (accepted values: true, false)
- backend_sa_account_file_encrypt - (Optional) Boolean flag which controls if Encryption Services are enabled for File storage. (accepted values: true, false)
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
