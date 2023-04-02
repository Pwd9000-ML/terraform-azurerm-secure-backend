terraform {
  required_version = "~> 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.36.0"
    }
  }
}
