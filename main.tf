/* 
Configure the Azure Provider to...
  ... use latest non-beta version (see Azure Provider changelog on Github: https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md)
  ... connect to the subscription "Enterprise Dev/Test"
  */
  provider "azurerm" {
    version         = "~>1.44.0"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    }

# Create resource group
  resource "azurerm_resource_group" "vm" {
    name     = var.resource_group_name
    location = var.location
    tags     = var.tags
    }

# Get the existing subnet of the virtual network
  data "azurerm_subnet" "existing" {
    name                 = var.subnet_name
    virtual_network_name = var.vnet_name
    resource_group_name  = var.vnet_rg
    }

# Create network interface for virtual machine
  resource "azurerm_network_interface" "vm" {
    name                      = "nic_${var.vm_hostname}"
    location                  = azurerm_resource_group.vm.location
    resource_group_name       = azurerm_resource_group.vm.name
    
    ip_configuration {
      name                          = "ipconfig1"
      subnet_id                     = data.azurerm_subnet.existing.id
      private_ip_address_allocation = var.private_ip_address_allocation
      }

    tags = var.tags
    }

# Generate random text for a unique storage account name
  resource "random_id" "vm-sa" {
    keepers = {
      vm_hostname = var.vm_hostname
      }

    byte_length = 8
    }

# Create storage account for boot diagnostics
  resource "azurerm_storage_account" "vm-sa" {
    name                     = "bootdiag${lower(random_id.vm-sa.hex)}"
    resource_group_name      = azurerm_resource_group.vm.name
    location                 = var.location
    account_tier             = var.account_tier
    account_replication_type = var.account_replication_type
    tags                     = var.tags
    }

# Create virtual machine
  resource "azurerm_virtual_machine" "vm-windows" {
    name                          = var.vm_hostname
    location                      = var.location
    resource_group_name           = azurerm_resource_group.vm.name
    network_interface_ids         = ["${azurerm_network_interface.vm.id}"]
    vm_size                       = var.vm_size
    delete_os_disk_on_termination = var.delete_os_disk_on_termination

    storage_image_reference {
      publisher = var.vm_os_publisher
      offer     = var.vm_os_offer
      sku       = var.vm_os_sku
      version   = var.vm_os_version
      }

    storage_os_disk {
      name              = "osdisk_${var.vm_hostname}"
      create_option     = "FromImage"
      caching           = "ReadWrite"
      managed_disk_type = var.storage_account_type
      }

    os_profile {
      computer_name  = var.vm_hostname
      admin_username = var.admin_username
      admin_password = var.admin_password
      }

    os_profile_windows_config {
      provision_vm_agent        = "true"
      enable_automatic_upgrades = "true"
      winrm {
        protocol        = "http"
        certificate_url = ""
        }
      }

    boot_diagnostics {
      enabled     = var.boot_diagnostics
      storage_uri = azurerm_storage_account.vm-sa.primary_blob_endpoint
      }

    tags = var.tags
    }

# Install IIS on VM
  resource "azurerm_virtual_machine_extension" "install-iis" {
    name                 = var.vm_hostname
    virtual_machine_id   = azurerm_virtual_machine.vm-windows.id    
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"

    settings = <<SETTINGS
      {
          "commandToExecute": "powershell.exe Set-ExecutionPolicy Bypass; Get-WindowsOptionalFeature -Online -FeatureName IIS* | Enable-WindowsOptionalFeature -Online"
      }
    SETTINGS

  }
