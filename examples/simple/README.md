# Terraform Simple Example - Backend

## Description

The following example files can be used to demo the module called backend under path Modules/backend.  
The example contains one terraform file (main.tf) and .tfvars file (terraform-demo.auto.tfvars)  
The main.tf file can be run to create a secure terraform environment backend as described in the module readme.  

## Usage

1. Clone or copy the files in this path to a local directory and open a command prompt.
2. Amend `main.tf` and `terraform-demo.auto.tfvars` with desired variables.
3. Log into azure using CLI: `az login`
4. **BUILD:**

    ```hcl
    terraform init
    terraform plan -out deploy.tfplan
    terraform apply deploy.tfplan
    ```

5. **DESTROY:**

    ```hcl
    terraform plan -destroy -out destroy.tfplan
    terraform apply destroy.tfplan
    ```

## Migrating the backend state file (optional)

After the backend infrastructure is setup from steps above (1-4):  

- Uncomment relevant lines from main.tf and provide values for:
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
| <a name="input_location"></a> [location](#input\_location) | Required Input - Location in azure where resources will be created. (ONLY accepted values [validation]: uksouth, westeurope, centralus, eastasia) | `string` | `"uksouth"` | no |
| <a name="input_region"></a> [region](#input\_region) | Optional Input - Regional map based on location. (used for naming conventions in locals) | `map(string)` | <pre>{<br>  "centralus": "NA",<br>  "eastasia": "APAC",<br>  "uksouth": "UK",<br>  "westeurope": "EMEA"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->