# 1. அஸூர் ப்ரோவைடர் கன்ஃபிகரேஷன் (Azure Provider Setup)
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

# 2. ஏற்கனவே உள்ள உங்களது Azure Key Vault-ஐ லிங்க் செய்ய (Data Source)
data "azurerm_key_vault" "existing_kv" {
  name                = "Praveen2005"          # உங்களது Key Vault பெயர்
  resource_group_name = "Praveen05"            # உங்களது Resource Group பெயர்
}

# 3. நீங்கள் உருவாக்கிய 4 சீக்ரெட்களையும் ரீட் செய்தல் (Reading Secrets)
data "azurerm_key_vault_secret" "dev" {
  name         = "Dev-Environment"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

data "azurerm_key_vault_secret" "qa" {
  name         = "QA-Environment"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

data "azurerm_key_vault_secret" "uat" {
  name         = "UAT-Environment"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

data "azurerm_key_vault_secret" "prod" {
  name         = "Production-Environment"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

# 4. அவுட்புட் செக் செய்ய (டெஸ்டிங் செய்ய மட்டும் - இது சீக்ரெட் வேல்யூவை காட்டும்)
output "dev_secret_value" {
  value     = data.azurerm_key_vault_secret.dev.value
  sensitive = true
}
