# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, I wrote a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
To run this project you need to follow 3 main processes:

1. Assign the policy to the azure policy system:

to do this: run the following command from the directory that contains the code:

`az policy definition create --name "name of the policy" --rules rule.json`
 
where rule.json is the file containing the policy, in our cause tag_policy.json
and to apply it use the following command: 

`az policy assignment create --name "name of the policy" --policy "name of the policy jsut created"`

#### Use packer to create the image

you will now use packer to create a VM image to later deploy with terraform 
before creating the image, make sure that you are logged in using the command:

`az login` 

Before you run the build, you will have to replace the resource-group value with the name of a resource-group in your configuration.
Once you are logged in, to create the image, run packer with the following command:

`packer build -var "varname=varvalue" ubuntu.pkr.hlc`

and add a `-var "varname=varvalue"` for each of the variables related to your account:
* client_id
* client_secret
* subscription_id
* tenant_id

this should create an image, that you can visualize by usign 

`az image list`


####(optional) import existing resource group into terraform

*optional if you want to use an already existing resource group*:
This will allow you to use terraform with an existing resource group, in case you are not allowed to create a new one
obtain the subscription id from the resource:

`az group show --name legacy-resource-group --query id --output tsv`

use the output in this import command:

terraform import azurerm_resource_group.legacy-resource-group [output of the previous command]

you should obtain a result like the next image
<img width="587" alt="image" src="https://user-images.githubusercontent.com/106270843/193462379-0891f3f9-c412-4783-b4a4-5447ec431127.png">

#### Use terraform to create the infrastructure
you will have to edit the files to have the resource group with the name that you desire.
you will also hav eto provide the following inputs:
* counter: the number of VMs to create
* prefix: prefix for the resources
* username: username for the VM
* password: password for the VM

to obtain a view of the expected output of launching the terraform applicationuse the following command:

`terraform plan -out solution.plan`

it will create a file solution.plan that you can use to apply the changes with this command:

`terraform apply`

once the changes are done you can see the result in the portal



### Output
hte outputs are the creation and assignment of a policy:
<img width="682" alt="tagging_policy_assigned" src="https://user-images.githubusercontent.com/106270843/193462603-0d64a849-8abe-47fe-a675-6e8e79b57bec.png">


creation of a VM image with packer:
<img width="778" alt="image" src="https://user-images.githubusercontent.com/106270843/193462598-8a43e4b6-242f-438a-9447-a21e5a00ab47.png">

creation of a solution.plan file and deployment of the infrastructure 
[see file solution.plan]
