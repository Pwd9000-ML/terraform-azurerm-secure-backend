##################################################
# PROVIDERS                                      #
##################################################
provider "azuread" {}
provider "azurerm" {}

##################################################
# BACKEND                                        #
##################################################
#terraform {
#    backend "azurerm" {
#        resource_group_name  = "BackendRG"
#        storage_account_name = "backendsaname0001"
#        container_name       = "backend-remote-state"
#        key                  = "terraform.tfstate"
#    }
#}

##################################################
# VARIABLES                                      #
##################################################
variable "location" {
  type    = string
  default = "westeurope"
}

variable "region" {
  type = map(string)
  default = {
    westeurope = "EMEA"
    centralus  = "NA"
    eastasia   = "APAC"
  }
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
  }
  # Error is input variable "location" does not match locals location map
  validate_input_location = local.locations[var.location]
}

##################################################
# MODULES                                        #
##################################################
module "backend" {
  source                       = "github.com/Pwd9000-ML/terraform-azurerm-secure-backend"
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