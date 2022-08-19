terraform {
  required_version = "~> 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.19.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.27.0"
    }
  }
}
