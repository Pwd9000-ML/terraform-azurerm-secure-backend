[![Manual-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/manual-test-release.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/manual-test-release.yml) [![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-secure-backend/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

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

<!-- END_TF_DOCS -->