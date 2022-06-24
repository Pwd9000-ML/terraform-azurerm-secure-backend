terraform {
  required_version = "~> 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.11.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.24.0"
    }
  }
}
