##################################################
# VARIABLES                                      #
##################################################
variable "backend_resource_group_name" {
  type        = string
  default     = "BackendRG"
  description = "The name for the backend resource group that will home the backend storage account and backend key vault. (Default: BackendRG)"
}

variable "backend_storage_account_name" {
  type        = string
  default     = "tfbackendsa"
  description = "The name for the backend storage account that will home the backend and primary state blob containers. (Unique all lowercase)"
}

variable "backend_sa_access_tier" {
  type        = string
  default     = "Hot"
  description = "The access tier of the backend storage account. (accepted values: Cool, Hot)"
}

variable "backend_sa_account_kind" {
  type        = string
  default     = "BlobStorage"
  description = "Defines the Kind of account. (accepted values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2)"
}

variable "backend_sa_account_tier" {
  type        = string
  default     = "Standard"
  description = "Defines the Tier to use for this storage account. (accepted values: Standard, Premium. For FileStorage accounts only Premium is valid.)"
}

variable "backend_sa_account_repl" {
  type        = string
  default     = "LRS"
  description = "Defines the type of replication to use for this storage account. (accepted values: LRS, GRS, RAGRS, ZRS)"
}

variable "common_tags" {
  type = map(string)
  default = {
    CommonTag1 = "demo1"
    CommonTag2 = "This is a demo"
  }
  description = "A map of key value pairs that is used to tag resources created. (Default: demo map)"
}

variable "environment" {
  type        = string
  default     = "Development"
  description = "Value to describe the environment. Primarily used for tagging and naming resources. (Default: Development)"
}

variable "kv_name" {
  type        = string
  default     = "terraform-kv"
  description = "The name for the backend key vault that will home terraform secrets e.g. terraform ARM_CLIENT_ID and ARM_CLIENT_SECRET. (Unique all lowercase)"
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Location in azure where resources will be created. (Default: uksouth)"
}

variable "primary_resource_group_name" {
  type        = string
  default     = "PrimaryRG"
  description = "The name for the primary resource group with 'terraform-contributor' role assigned. (Default: BackendRG)"
}

variable "soft_delete_retention_days" {
  type        = number
  default     = "7"
  description = "Key Vault soft delete retention days. (Default: 7)"
}

variable "kv_sku" {
  type        = string
  default     = "standard"
  description = "Key Vault SKU. (Default: standard)"
}

variable "spn_name" {
  type        = string
  default     = "terraform-SPN"
  description = "Azure AD App & SPN name. (Default: terraform-SPN)"
}