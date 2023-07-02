##################################################
# VARIABLES                                      #
##################################################
variable "storage_account_name" {
  type        = string
  default     = ""
  description = "Specify a storage account name to be created for the backend"
}

variable "key_vault_name" {
  type        = string
  default     = ""
  description = "Specify a key vault name name to be created for the frontend"
}