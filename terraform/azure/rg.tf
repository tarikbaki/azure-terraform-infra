resource "azurerm_resource_group" "resource_group_name" {
  name     = "rm-rg-${var.environment}"
  location = var.region
}