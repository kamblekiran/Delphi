terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}