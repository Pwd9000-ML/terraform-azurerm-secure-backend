##################################################
# VARIABLES                                      #
##################################################
variable "backend_resource_group_name" {
  type    = string
  default = "BackendRG"
  description = "Optional Input - The name for the backend resource group that will home the backend storage account and backend key vault. (Default: BackendRG)"
}

variable "backend_storage_account_name" {
  type = string
  description = "Required Input - The name for the backend storage account that will home the backend and primary state blob containers. (Unique all lowercase)"
}

variable "common_tags" {
  type = map(string)
  default = {
    CommonTag1 = "demo1"
    CommonTag2 = "This is a demo"
  }
  description = "Optional Input - A map of key value pairs that is used to tag resources created. (Default: demo map)"
}

variable "environment" {
  type    = string
  default = "Development"
  description = "Optional Input - Value to describe the environment. Primarily used for tagging and naming resources. (Default: Development)"
}

variable "kv_name" {
  type = string
  description = "Required Input - The name for the backend key vault that will home terraform secrets e.g. terraform ARM_CLIENT_ID and ARM_CLIENT_SECRET. (Unique all lowercase)"
}

variable "lob" {
  type    = string
  default = "IT"
  description = "Optional Input - Value to describe the Line Of Business. Primarily used for tagging and naming resources. (Default: IT)"
}

variable "location" {
  type    = string
  default = "westeurope"
  description = "Optional Input - Location in azure where resources will be created. (Default: westeurope)"
}

variable "primary_resource_group_name" {
  type    = string
  default = "PrimaryRG"
  description = "Optional Input - The name for the primary resource group with 'terraform-contributor' role assigned. (Default: BackendRG)"
}

variable "region" {
  type    = string
  default = "EMEA"
  description = "Optional Input - The geographical region where resources are created. (Default: EMEA)"
}