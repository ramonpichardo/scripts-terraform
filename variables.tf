variable "account_tier" {
  description = "The tier of this storage account."
}

variable "account_replication_type" {
  description = "The type of replication used for this storage account."
}

variable "admin_password" {
  description = "The admin password to be used on the VMs that will be deployed. The password must meet the complexity requirements of Azure."
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
}

variable "boot_diagnostics" {
  description = "(Optional) Enable or Disable boot diagnostics."
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics."
}

variable "data_disk" {
  type        = string
  description = "Set to true to add a datadisk."
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size."
  default     = ""
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type."
}

variable "delete_os_disk_on_termination" {
  description = "Delete datadisk when machine is terminated."
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based. Only used in conjunction with vm_os_id."
  default     = "true"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "nb_instances" {
  description = "Specify the number of vm instances."
  default     = "1"
}

variable "nb_public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  default     = "1"
}

variable "nsg_id" {
  description = "A Network Security Group ID to attach to the network interface."
  default = ""
}

variable "private_ip_address_allocation" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
}

variable "public_ip_dns" {
  description = "Optional globally unique per datacenter region domain name label to apply to each public ip address. E.g., thisvar.varlocation.cloudapp.azure.com where you specify only thisvar here. This is an array of names which will pair up sequentially to the number of public ips defined in var.nb_public_ip. One name or empty string is required for every public ip. If no public ip is desired, then set this to an array with a single empty string."
  default     = [""]
}

variable "remote_port" {
  description = "Remote TCP port to be used for access to the VMs created via the NSG applied to the NICs."
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
}

variable "ssh_key" {
  description = "Path to the public key to be used for SSH access to the VM.  Only used with non-Windows VMs and can be left as-is even if using Windows VMs. If specifying a path to a certification on a Windows machine to provision a Linux VM use the / in the path versus backslash. E.g. c:/home/id_rsa.pub"
  default     = "~/.ssh/id_rsa.pub"
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
}

variable "subnet_name" {
  description = "The subnet name of the virtual network where the virtual machines will reside."
}

variable "subscription_id" {
  type        = string
  description = "Select the Azure subscription by its GUID. The Azure subscription GUID is a Version 4 UUID."
}

variable "tags" {
  type        = map
  description = "A map of the tags to use on the resources that are deployed with this module."
  default = {
    Environment = "Dev"
    Owner       = "Infrastructure" 
    Source      = "Terraform"
  }
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "vm_hostname" {
  description = "Local name of the VM."
}

variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image. Note, need to provide is_windows_image = true for windows custom images."
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
}

variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
}

variable "vnet_name" {
  description = "The name of the virtual network where the virtual machines will reside."
}

variable "vnet_rg" {
  description = "Specifies the name of the resource group the virtual network is located in."
}
