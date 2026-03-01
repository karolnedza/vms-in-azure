esource "azurerm_resource_group" "rg" {
  name     = "rg-mgn-demo"
  location = "Southeast Asia"
}

# ================================
# Singapore (Southeast Asia)
# ================================

resource "azurerm_virtual_network" "vnet_sg" {
  name                = "vnet-singapore"
  location            = "Southeast Asia"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet_sg" {
  name                 = "subnet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_sg.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "nsg_sg" {
  name                = "nsg-sg"
  location            = azurerm_virtual_network.vnet_sg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
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
    name                       = "Allow-VNet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.2.0.0/16"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

   security_rule {
    name                       = "Allow-iperf"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5201"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "Allow-iperf-udp"
    priority                   = 125
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "5201"
    source_address_prefix      = "20.213.57.117/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_sg.id
  network_security_group_id = azurerm_network_security_group.nsg_sg.id
}

resource "azurerm_public_ip" "pip_sg" {
  name                = "pip-sg"
  location            = azurerm_virtual_network.vnet_sg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_sg" {
  name                = "nic-sg"
  location            = azurerm_virtual_network.vnet_sg.location
  resource_group_name = azurerm_resource_group.rg.name
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_sg.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_sg.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_sg" {
  name                = "vm-singapore"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.vnet_sg.location
  size                = "Standard_D8s_v5"
  admin_username      = "azureuser"
  admin_password      = "YourStrongPassword123!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_sg.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ================================
# Australia East
# ================================

resource "azurerm_virtual_network" "vnet_au" {
  name                = "vnet-australia"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "subnet_au" {
  name                 = "subnet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_au.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_network_security_group" "nsg_au" {
  name                = "nsg-au"
  location            = azurerm_virtual_network.vnet_au.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
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
    name                       = "Allow-VNet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.1.0.0/16"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

     security_rule {
    name                       = "Allow-iperf"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5201"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

     security_rule {
    name                       = "Allow-iperf-udp"
    priority                   = 125
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "5201"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}
resource "azurerm_subnet_network_security_group_association" "au_assoc" {
  subnet_id                 = azurerm_subnet.subnet_au.id
  network_security_group_id = azurerm_network_security_group.nsg_au.id
}

resource "azurerm_public_ip" "pip_au" {
  name                = "pip-au"
  location            = azurerm_virtual_network.vnet_au.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_au" {
  name                = "nic-au"
  location            = azurerm_virtual_network.vnet_au.location
  resource_group_name = azurerm_resource_group.rg.name
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_au.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_au.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_au" {
  name                = "vm-australia"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.vnet_au.location
  size                = "Standard_D8s_v5"
  admin_username      = "azureuser"
  admin_password      = "YourStrongPassword123!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_au.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
