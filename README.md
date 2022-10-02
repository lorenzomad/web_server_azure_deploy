# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
**Your words here**


#### Use packer to create the image

to create the image, run packer with the following command :
packer build -var "varname=varvalue" ubuntu.pkr.hlc

and add a -var for each of the variables related to your account:
client_id
client_secret
subscription_id
tenant_id


#### import existing resource into terraform

obtain the subscription id from the resource

az group show --name legacy-resource-group --query id --output tsv

use the output in this import command:

terraform import azurerm_resource_group.legacy-resource-group --previous output

This will allow you to use terraform with an existing resource group, in case you are not allowed to create a new one


### Output
**Your words here**

