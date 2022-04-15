terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.20.0"
    }
  }
}
