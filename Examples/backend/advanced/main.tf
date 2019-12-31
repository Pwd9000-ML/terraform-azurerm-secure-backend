##################################################
# PROVIDERS                                      #
##################################################
provider "azuread" {
  alias     = "az_ad_alias1"
  tenant_id = var.tenantid
}

provider "azurerm" {
  alias           = "az_rm_alias1"
  subscription_id = var.subscriptionid
}

##################################################
# VARIABLES                                      #
##################################################
variable "BillingCode" {
  type = map(string)
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
  default = {
    IT          = "IT"
    Development = "DEV"
    Research    = "RND"
  }
}
variable "environment" {
  type = string
}
variable "lob" {
  type = string
}
variable "location" {
  type    = string
  default = "westeurope"
}
variable "prefix" {
  type = string
}
variable "region" {
  type = map(string)
  default = {
    westeurope = "EMEA"
    centralus  = "NA"
    eastasia   = "APAC"
  }
}
variable "tenantid" {
  type = string
}
variable "subscriptionid" {
  type = string
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
  source = "..\\..\\Modules\\backend"
  providers = {
    azuread = azuread.az_ad_alias1
  }
  backend_resource_group_name  = local.backendResourceGroupName
  backend_storage_account_name = local.backendStorageName
  common_tags                  = local.common_tags
  environment                  = var.environment
  kv_name                      = local.backendkeyvaultName
  lob                          = var.lob
  location                     = var.location
  primary_resource_group_name  = local.primaryResourceGroupName
  region                       = var.region[var.location]
}

##################################################
# RESOURCES                                      #
##################################################
resource "random_integer" "sa_num" {
  min = 0001
  max = 9999
}