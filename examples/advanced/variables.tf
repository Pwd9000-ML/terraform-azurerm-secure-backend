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