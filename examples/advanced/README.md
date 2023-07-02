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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | github.com/Pwd9000-ML/terraform-azurerm-secure-backend | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.sa_num](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_BillingCode"></a> [BillingCode](#input\_BillingCode) | Optional Input - Billing code map based on environment. (used for common tags defined in locals) | `map(string)` | <pre>{<br>  "Development": "100",<br>  "POC": "103",<br>  "Production": "105",<br>  "QA": "102",<br>  "Testing": "104",<br>  "UAT": "101"<br>}</pre> | no |
| <a name="input_CostCenter"></a> [CostCenter](#input\_CostCenter) | Optional Input - Cost center map based on line of business. (used for naming conventions defined in locals) | `map(string)` | <pre>{<br>  "Development": "DEV",<br>  "IT": "IT",<br>  "Research": "RND"<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Required Input - Value to describe the environment. Primarily used for tagging and naming resources. (used for naming conventions defined in locals). Examples: Development, UAT, QA, POC, Testing, Production. | `string` | n/a | yes |
| <a name="input_lob"></a> [lob](#input\_lob) | Required Input - Describes line of business. (used for naming conventions defined in locals; accepted values: IT, Development, Research) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Required Input - Location in azure where resources will be created. (ONLY accepted values [validation]: uksouth, westeurope, centralus, eastasia) | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Required Input - Used for naming conventions defined in locals | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Optional Input - Regional map based on location. (used for naming conventions defined in locals) | `map(string)` | <pre>{<br>  "centralus": "NA",<br>  "eastasia": "APAC",<br>  "uksouth": "UK",<br>  "westeurope": "EMEA"<br>}</pre> | no |
| <a name="input_subscriptionid"></a> [subscriptionid](#input\_subscriptionid) | Required Input - Subscription ID used for azurerm provider | `string` | n/a | yes |
| <a name="input_tenantid"></a> [tenantid](#input\_tenantid) | Required Input - Tenant ID of azure AD tenant used for azuread provider | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->