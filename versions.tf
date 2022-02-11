terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.93.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.18.0"
    }
  }
}
