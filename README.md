# What is Terraform 
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It enables users to define and provision infrastructure resources, such as virtual machines, networks, and databases, in a declarative configuration language. Terraform facilitates the automation and management of infrastructure across various cloud providers and on-premises environments.

It is commonly used to streamline the deployment and scaling of infrastructure, ensuring consistency and reproducibility, and allowing teams to version-control their infrastructure configurations.

# Configuration Files
- main.tf: Main Terraform configuration file.
- variables.tf: Declare variables used in the configurations.
- tfvars/(dev,qa3,prod).tfvars: Variable values for the each environment. These are the files that differ per environment.
- tfvars/(dev,uat,prod)-backend.conf: Configuration for Terraform backend (e.g., remote state)

# Requirements
In order to run this Terraform code we need to have installed:
- Terraform: https://developer.hashicorp.com/terraform/install
- Azure CLI: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
- Azure storage account to store state files(Backend): https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli

# Getting Started
These are the steps that needs to be followed in order to provision the infrastructure using this Terraform code, the example is given for dev environment:
1.	Open the terminal and position yourself in the root of the Terraform repository and start executing the following commands
2.	terraform init -backend-config=tfvars/dev.backend.conf - Initialize terraform modules, download requied providers and connect to the backend
3.	terraform workspace select -or-create dev - Workspaces are used to manage multiple environments, with this we have a state file for each env
4.	terraform plan -var-file=tfvars/dev.tfvars - A dry run that will show you what changes are going to happen
5.	terraform apply -var-file=tfvars/dev.tfvars - An actual run that will prompt user to type yes to confirm the changes

# More documentation
More documentation and resources regarding Terraform.
- [Terraform getting started](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
- [Terraform Workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
- [Terraform Backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [Configuring Backend in Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)