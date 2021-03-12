##################################################
# PROVIDERS                                      #
##################################################
provider "azuread" {
  alias     = "az_ad_alias1"
  tenant_id = var.tenantid
}

provider "azurerm" {
  features {}
  alias           = "az_rm_alias1"
  subscription_id = var.subscriptionid
}

##################################################
# VARIABLES                                      #
##################################################
variable "BillingCode" {
  type = map(string)
  description = "Optional Input - Billing code map based on environment. (used for common tags defined in locals)"
  default = {
    Development = "100"
    UAT         = "101"
    QA          = "102"
    POC         = "103"
    Testing     = "104"
    Production  = "105"
  }
}

variable "CostCenter" {
  type = map(string)
  description = "Optional Input - Cost center map based on line of business. (used for naming conventions defined in locals)"
  default = {
    IT          = "IT"
    Development = "DEV"
    Research    = "RND"
  }
}

variable "environment" {
  type = string
  description = "Required Input - Value to describe the environment. Primarily used for tagging and naming resources. (used for naming conventions defined in locals)"
}

variable "lob" {
  type = string
  description = "Required Input - Describes line of business. (used for naming conventions defined in locals; accepted values: IT, Development, Research)"
}

variable "location" {
  type    = string
  description = "Required Input - Location in azure where resources will be created. (ONLY accepted values [validation]: westeurope, centralus, eastasia)"
}

variable "prefix" {
  type = string
  description = "Required Input - Used for naming conventions defined in locals"
}

variable "region" {
  type = map(string)
  description = "Optional Input - Regional map based on location. (used for naming conventions defined in locals)"
  default = {
    westeurope = "EMEA"
    centralus  = "NA"
    eastasia   = "APAC"
  }
}

variable "tenantid" {
  type = string
  description = "Required Input - Tenant ID of azure AD tenant used for azuread provider"
}

variable "subscriptionid" {
  type = string
  description = "Required Input - Subscription ID used for azurerm provider"
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
  }
  # Error is input variable "location" does not match locals location map
  validate_input_location = local.locations[var.location]
}

##################################################
# MODULES                                        #
##################################################
module "backend" {
  source = "github.com/Pwd9000-ML/terraform-azurerm-secure-backend"
  providers = {
    azuread = azuread.az_ad_alias1
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