# Terraform Advanced Example - Backend

## Description

This example is the same as the simple example, but uses more advanced inputs and logic with the deployment and variables.  
The following example files can be used to demo the module called backend under path Modules/backend.  
The example contains:  

- main terraform file (main.tf)
- backend terraform file (backend.tf)
- .tfvars file (terraform.auto.tfvars)  

The `main.tf` and `terraform.auto.tfvars` files can be amended to create a secure terraform environment backend as described in the module readme.  
Amend `terraform.auto.tfvars` with relevant SubscriptionID and TenantID that will be used with the azuread and azurerm provider.  
Amend `backend.tf` to migrate state to remote state.  

## Usage

1. Clone or copy the files in this path to a local directory and open a command prompt.
2. Amend `main.tf` and `terraform.auto.tfvars` with desired variables.
3. Log into azure using CLI "az login".
4. BUILD:

    ```hcl
    terraform init
    terraform plan -out deploy.tfplan
    terraform apply deploy.tfplan
    ```

5. DESTROY:

    ```hcl
    terraform plan -destroy -out destroy.tfplan
    terraform apply destroy.tfplan
    ```

## Migrating the backend state file. (Optional)

After the backend infrastructure is setup from steps above (1-4):  

- Uncomment relevant lines from backend.tf and provide values for:
  - resource_group_name = "" (backend resource group name. This value will also be in "setup.log")
  - storage_account_name = "" (backend storage account name. This value will also be in "setup.log")
  - container_name = "backend-remote-state"
  - key = "terraform.tfstate"
- Run: Terraform init
- Delete any local .tfstate or .tfstate.backup files as these may contain sensitive information.

The backend state is now migrated to the backend storage account and container for the backend.  
To cleanup the demo run: terraform destroy and delete the .terraform directory. (contains remote backend state config).  
  
## Input variables
  
- `BillingCode` - (Optional) Billing code map based on environment. (defined in locals).
- `CostCenter` - (Optional) Cost center map based on line of business. (defined in locals).
- `environment` - (Required) Value to describe the environment. (defined in locals). Accepted values: Development, UAT, QA, POC, Testing, Production.
- `lob` - (Required) Describes line of business. (defined in locals). Accepted values: IT, Development, Research.
- `location` - (Required) Location in azure where resources will be created. ([Validated] ONLY accepted values: uksouth, westeurope, centralus, eastasia).
- `prefix` - (Required) Used for naming conventions. (defined in locals).
- `region` - (Optional) Regional map based on location. (defined in locals).
- `tenantid` - (Required) Tenant ID of azure AD tenant used for azuread provider.
- `subscriptionid` - (Required) Subscription ID used for azurerm provider.

`Required input variables` can be changed or set in `terraform.auto.tfvars`
