resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet-name
  location            = var.location
  resource_group_name = var.rg-name
  address_space       = var.vnet-address-space
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet-name
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet-add-space
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = var.rg-name
  tags                = local.tags

  security_rule {

    name                       = "rule-1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {

    name                       = "rule-2"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {

    name                       = "rule-3"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {

    name                       = "rule-4"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}