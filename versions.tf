terraform {
  required_version = ">= 1.6.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
  }
}
