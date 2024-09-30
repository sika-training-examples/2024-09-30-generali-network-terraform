resource "azurerm_resource_group" "main" {
  name     = "example-generali-network"
  location = "westeurope"
}

resource "azurerm_virtual_network" "main" {
  name                = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  for_each = {
    "ondrejsika" = ["10.0.1.0/24"]
    "foo"        = ["10.0.2.0/24"]
  }

  name                 = each.key
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = "example-generali-network"
  address_prefixes     = each.value
}

module "hello_world_network" {
  source = "git::https://gitlab.sikademo.com/generali/generali-terraform-modules.git//network?ref=master"

  name          = "hello-world"
  address_space = ["10.0.0.0/16"]

  subnets = {
    "foo" = ["10.0.1.0/24"]
    "bar" = ["10.0.2.0/24"]
  }
}
