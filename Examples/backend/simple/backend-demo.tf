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
#        resource_group_name = ""
#        storage_account_name = ""
#        container_name = "backend-remote-state"
#        key = "terraform.tfstate"
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
  backendStorageName  = "tfstate${lower(var.region[var.location])}0001"
  backendkeyvaultName = "tfkv${lower(var.region[var.location])}0001"

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
  source = "github.com/Pwd9000-ML/Terraform/Modules/backend"
  backend_storage_account_name = local.backendStorageName 
  kv_name = local.backendkeyvaultName 
  location = var.location 
  region = var.region[var.location] 
}