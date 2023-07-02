##################################################
# VARIABLES                                      #
##################################################
variable "location" {
  type        = string
  default     = "uksouth"
  description = "Required Input - Location in azure where resources will be created. (ONLY accepted values [validation]: uksouth, westeurope, centralus, eastasia)"
}

variable "region" {
  type        = map(string)
  description = "Optional Input - Regional map based on location. (used for naming conventions in locals)"
  default = {
    westeurope = "EMEA"
    centralus  = "NA"
    eastasia   = "APAC"
    uksouth    = "UK"
  }
}