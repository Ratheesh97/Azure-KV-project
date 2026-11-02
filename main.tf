# 1. அஸூர் ப்ரோவைடர் (Azure Provider Setup)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2. ரிசோர்ஸ் குரூப் (Resource Group)
resource "azurerm_resource_group" "rg" {
  name     = "kv-rg"
  location = "East US"
}

# 3. தற்போதைய அஸூர் கிளையன்ட் விவரங்கள் (To get Tenant ID)
data "azurerm_client_config" "current" {}

# 4. கீ வால்ட் (Azure Key Vault)
resource "azurerm_key_vault" "kv" {
  name                        = "my-unique-kv-2026" # இந்த பெயர் உலகளவில் தனித்துவமாக (Unique) இருக்க வேண்டும்
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Create", "Delete", "List"
    ]

    secret_permissions = [
      "Get", "Set", "Delete", "List"
    ]
  }
}
