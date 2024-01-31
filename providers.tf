terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id

  skip_provider_registration = true
}
