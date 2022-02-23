# Infrastructure as Code with Terraform

![terraform diagram](../public/assets/img/terraform-diagram.png)

## Table of Contents

- [Infrastructure as Code with Terraform](#infrastructure-as-code-with-terraform)
  - [Table of Contents](#table-of-contents)
  - [What is Terraform](#what-is-terraform)
  - [Install Terraform](#install-terraform)
  - [Terraform Architecture](#terraform-architecture)
  - [Terraform default file/folder structure](#terraform-default-filefolder-structure)
  - [Set up AWS keys as an ENV in windows machine](#set-up-aws-keys-as-an-env-in-windows-machine)
  - [Terraform Commands](#terraform-commands)

## What is Terraform

## Install Terraform

## Terraform Architecture

## Terraform default file/folder structure

- Terraform uses `.tf` extension
- `main.tf` is the runner file. It executes everything. Entry point into our script.
- `variable.tf` file holds our variables. Needs to be ignored in our `.gitignore`

## Set up AWS keys as an ENV in windows machine

- `AWS_ACCESS_KEY_ID` for aws access keys
- `AWS_SECRET_ACCESS_KEY` for aws secret
- Press Windows Key and type `env`
- Click on `Environment Variables`
- Click on `New...` under `User variables`
- Add your variables

## Terraform Commands

- `terraform` shows us the list of commands
- `terraform init` to initialize Terraform (prepare it for other commands)
- `terraform plan` checks the script for syntax errors
- `terraform apply` runs the playbook (implements the script)
- `terraform destroy` to delete everything
- `terraform apply -target=<resourcename>.<name>` launch specific resource
