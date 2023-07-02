##################################################
# VARIABLES                                      #
##################################################
variable "BillingCode" {
  type        = map(string)
  description = "Billing code map based on environment. (used for common tags defined in locals)"
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
  type        = map(string)
  description = "Cost center map based on line of business. (used for naming conventions defined in locals)"
  default = {
    IT          = "IT"
    Development = "DEV"
    Research    = "RND"
  }
}

variable "environment" {
  type        = string
  default     = "Development"
  description = "Value to describe the environment. Primarily used for tagging and naming resources. (used for naming conventions defined in locals). Examples: Development, UAT, QA, POC, Testing, Production."
}

variable "lob" {
  type        = string
  default     = "IT"
  description = "Describes line of business. (used for naming conventions defined in locals; accepted values: IT, Development, Research)"
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Location in azure where resources will be created. (ONLY accepted values [validation]: uksouth, westeurope, centralus, eastasia)"
}

variable "prefix" {
  type        = string
  default     = "Demo"
  description = "Used for naming conventions defined in locals"
}

variable "region" {
  type        = map(string)
  description = "Regional map based on location. (used for naming conventions defined in locals)"
  default = {
    westeurope = "EMEA"
    centralus  = "NA"
    eastasia   = "APAC"
    uksouth    = "UK"
  }
}

variable "tenantid" {
  type        = string
  default     = null
  description = "Tenant ID of azure AD tenant used for azuread provider"
}

variable "subscriptionid" {
  type        = string
  default     = null
  description = "Subscription ID used for azurerm provider"
}