terraform {
  required_version = ">= 1.1.5"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.20"  # Update this line
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "newrelic" {
  region = "EU"
  account_id = "3815665"
  api_key = "eu01xxb4dc71143d8169ad6c4d472a16FFFFNRAL"
  # Valid regions are US and EU
}


provider "aws" {
  region = var.region
}