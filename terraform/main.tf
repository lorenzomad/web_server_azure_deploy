provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "Azuredevops"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    source = "Terraform"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    # allow inbound access from the virtual machines in the network
    name                       = "allowFromVMs"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = tolist(["VirtualNetwork",  "AzureLoadBalancer"])
    destination_address_prefix = "*"
  }
  
  security_rule {
    # lower priority deny everything else
    name                       = "denyInternetAccess"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    source = "Terraform"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-publicIP"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    source = "Terraform"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    source = "Terraform"
  }
}


resource "azurerm_lb" "main" {
  name = "${var.prefix}-lb"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  frontend_ip_configuration {
    name = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
    subnet_id = azurerm_network_interface.main.id
  }

  tags = {
    source = "Terraform"
  }

}

resource "azurerm_availability_set" "example" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    source = "Terraform"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                             = "${var.prefix}-VM"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  vm_size                          = "Standard_DS2_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "/subscriptions/83ab2601-ced6-4391-b0e4-f54b470eb775/resourceGroups/pkr-Resource-Group-kb8beydogf/providers/Microsoft.Compute/disks/pkroskb8beydogf"
  }

  storage_os_disk {
    name              = "${var.prefix}-VM-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
}

  os_profile {
    computer_name  = "APPVM"
    admin_username                  = "${var.username}"
    admin_password                  = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    source = "Terraform"
  }
}