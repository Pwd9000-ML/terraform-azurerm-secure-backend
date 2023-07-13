terraform {
  #backend "azurerm" {}
  backend "local" { path = "terraform-example2.tfstate" }
}

provider "azuread" {
  alias     = "az_ad_alias1"
  tenant_id = var.tenantid
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = true
    }
  }
  alias           = "az_rm_alias1"
  subscription_id = var.subscriptionid
}

##################################################
# LOCALS                                         #
##################################################
locals {
  common_tags = {
    BillingCode    = var.BillingCode[var.environment]
    CostCenter     = var.CostCenter[var.lob]
    Environment    = var.environment
    LineOfBusiness = var.lob
    Region         = var.region[var.location]
  }
  backendResourceGroupName = "${var.prefix}-Terraform-Backend-${lower(var.CostCenter[var.lob])}"
  backendStorageName       = "${lower(var.prefix)}tfstate${lower(var.CostCenter[var.lob])}${random_integer.sa_num.result}"
  backendkeyvaultName      = "${lower(var.prefix)}tfkv${lower(var.CostCenter[var.lob])}${random_integer.sa_num.result}"
  primaryResourceGroupName = "${var.prefix}-Terraform-Primary-${lower(var.CostCenter[var.lob])}"

  # Validation: 
  # This section validates input for location of available locations
  locations = {
    westeurope = "westeurope"
    centralus  = "centralus"
    eastasia   = "eastasia"
    uksouth    = "uksouth"
  }
  # Error if input variable "location" does not match locals location map
  validate_input_location = local.locations[var.location]
}

##################################################
# MODULES                                        #
##################################################
module "backend" {
  source  = "Pwd9000-ML/secure-backend/azurerm"
  version = ">= 1.3.0"
  providers = {
    azuread = azuread.az_ad_alias1
    azurerm = azurerm.az_rm_alias1
  }
  backend_resource_group_name  = local.backendResourceGroupName
  backend_storage_account_name = local.backendStorageName
  common_tags                  = local.common_tags
  environment                  = var.environment
  kv_name                      = local.backendkeyvaultName
  location                     = var.location
  primary_resource_group_name  = local.primaryResourceGroupName
}

##################################################
# RESOURCES                                      #
##################################################
resource "random_integer" "sa_num" {
  min = 0001
  max = 9999
}