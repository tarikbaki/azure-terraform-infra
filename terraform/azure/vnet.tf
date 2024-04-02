module "network" {
  source              = "Azure/network/azurerm"
  vnet_name           = "rm-${var.environment}-vnet"
  resource_group_name = azurerm_resource_group.resource_group_name.name
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["${var.environment}-subnet1", "${var.environment}-subnet2", "${var.environment}-subnet3"]

  use_for_each = true
  tags = {
    environment = "${var.environment}"
    terraform  = "true"
  }

  depends_on = [azurerm_resource_group.resource_group_name]
}