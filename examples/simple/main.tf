terraform {
  #backend "azurerm" {}
  backend "local" { path = "terraform-example1.tfstate" }
}

provider "azuread" {
}
provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = true
    }
  }
  resource_provider_registrations = "none"
}

##################################################
# LOCALS                                         #
##################################################
locals {
  backendStorageName  = "tfstate${lower(var.region[var.location])}${random_integer.sa_num.result}"
  backendkeyvaultName = "tfkv${lower(var.region[var.location])}${random_integer.sa_num.result}"

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
  source                       = "Pwd9000-ML/secure-backend/azurerm"
  version                      = ">= 1.3.0"
  backend_storage_account_name = local.backendStorageName
  kv_name                      = local.backendkeyvaultName
  location                     = var.location
}

##################################################
# RESOURCES                                      #
##################################################
resource "random_integer" "sa_num" {
  min = 0001
  max = 9999
}