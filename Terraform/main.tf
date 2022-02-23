# Terraform init - will download any required packages

# provider aws
provider "aws" {

  # let terraform know which region
  region = "eu-west-1"
}

# initialize with terraform

# what do we want to launch (type of service)
