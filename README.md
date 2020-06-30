# scripts-terraform-build-azure-vm
This repo is a template for building a new set of Azure Windows VMs.

### Core Build Files
**main.tf :** Core template execution plan to provision (i.e., build, change, and version) infrastructure using Terraform.

**variables.tf :** Defined valid variables with default values for core template execution plan file `main.tf`.  Variables listed alphabetically.

**terraform.auto.tfvars :** Contains override values for a specified set of variables defined in file `variables.tf`. This is the file to modify for each new build set. This file is also required in order to run the build plan in Terraform Enterprise.

### Terraform Enterprise - Environment Variables
The following five variables are added as **environment variables** within the Terraform Enterprise workspace for the build set:

| **Environment Variable Name** | **Environment Variable Value** | **Notes** |
|:----------------------:|:---------:|:-------------------|
| ARM_SUBSCRIPTION_ID | xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx | UUID-formatted Azure subscription ID. Get value via Azure Portal or run PowerShell command Get-AzSubscription. |
| ARM_CLIENT_ID | xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx | UUID-formatted Terraform Enterprise service account ID. | 
| ARM_TENANT_ID | xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx | UUID-formatted Azure Tenant ID. Get value via Azure Portal or run PowerShell command Get-AzSubscription. |
| ARM_CLIENT_SECRET | <sensitive – write only> | Value is stored in password management system: Infrastructure &rarr; Terraform &rarr; Terraform Azure Service Principal |
| CONFIRM_DESTROY | 1 | Terraform Enterprise will ask for confirmation of plan before destroying the defined resource(s). |
