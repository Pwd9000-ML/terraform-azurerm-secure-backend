terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.69.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.41.0"
    }
  }
}
