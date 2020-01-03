# Configure the Azure provider to connect to the subscription
provider "azurerm" {
  version         = "~>1.39.0"
  subscription_id = "UUID_subscription"
  tenant_id       = "UUID_tenant"
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg_learning_terraform_owner_name"
  location = "East US"
  
  tags     = {
    environment = "dev"
    owner       = "owner_name"
  }
}

# Use this data source to access information about an existing virtual network
data "azurerm_virtual_network" "vnet" {
  name                = "vnet_prod"
  resource_group_name = "rg_prod"
}

# Use this data source to access information about an existing subnet within an existing virtual network
data "azurerm_subnet" "snet" {
  name                 = "snet_test"
  virtual_network_name = "${data.azurerm_virtual_network.name}"
  resource_group_name  = "${data.azurerm_virtual_network.resource_group_name}"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "myTFNSG"
  location            = "East US"
  resource_group_name = ${azurerm_resource_group.rg.name}

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "test2020nic0"
  location                  = "East US"
  resource_group_name       = ${azurerm_resource_group.rg.name}
  network_security_group_id = ${azurerm_network_security_group.nsg.id}

  ip_configuration {
    name                          = "testconfig1"
    subnet_id                     = ${data.azurerm_subnet.snet.id}
    private_ip_address_allocation = "dynamic"
  }

  tags = {
    environment = "dev"
    owner       = "Owner Name"
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "test" {
  name                  = "test2020it"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_B1ms" # https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes

# Uncomment this line to delete the OS disk automatically when deleting the VM
# delete_os_disk_on_termination = true

# Uncomment this line to delete the data disks automatically when deleting the VM
# delete_data_disks_on_termination = true

  storage_image_reference {
    publisher           = "MicrosoftWindowsServer"
    offer               = "WindowsServer"
    sku                 = "2016-Datacenter-Server-Core-smalldisk"
    version             = "latest"
  }

  storage_os_disk {
    name                = "server-os"
    caching             = "ReadWrite"
    create_option       = "FromImage"
    managed_disk_type   = "Standard_LRS"
  }  

  os_profile {
    computer_name       = "${azurerm_virtual_machine.test.name}"
    admin_username      = "itadmin01"
    admin_password      = "Password2020!"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = "Pacific Standard Time"
  }
}
