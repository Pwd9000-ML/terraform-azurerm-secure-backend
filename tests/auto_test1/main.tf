
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = true
    }
  }
  skip_provider_registration = true
}

##################################################
# MODULE TO TEST                                 #
##################################################
module "backend" {
  source                       = "../.."
  backend_storage_account_name = "${lower(var.storage_account_name)}${random_integer.num.result}"
  kv_name                      = "${lower(var.key_vault_name)}${random_integer.num.result}"
}

##################################################
# RESOURCES                                      #
##################################################
resource "random_integer" "num" {
  min = 0001
  max = 9999
}