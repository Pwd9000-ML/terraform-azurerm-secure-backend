##################################################
# VARIABLES                                      #
##################################################
variable "backend_resource_group_name" {
  type    = string
  default = "BackendRG"
}

variable "backend_storage_account_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {
    CommonTag1 = "demo1"
    CommonTag2 = "This is a demo"
  }
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "kv_name" {
  type = string
}

variable "lob" {
  type    = string
  default = "IT"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "primary_resource_group_name" {
  type    = string
  default = "PrimaryRG"
}

variable "region" {
  type    = string
  default = "EMEA"
}