terraform {
  required_version = "~> 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.62"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.5.0"
    }
  }
}
