# scripts-terraform-build-azure-vm
This repo is a template for building a new set of Azure Windows VMs.

### Core Build Files
**main.tf :** Core template execution plan to provision (i.e., build, change, and version) infrastructure using Terraform.

**variables.tf :** Defined valid variables with default values for core template execution plan file `main.tf`.  Variables listed alphabetically.

**terraform.auto.tfvars :** Contains override values for a specified set of variables defined in file `variables.tf`. This is the file to modify for each new build set. This file is also required in order to run the build plan in Terraform Enterprise.
