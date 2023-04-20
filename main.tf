terraform {
  required_version = ">= 1.1.5"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.20"  # Update this line
    }
  }
}

provider "newrelic" {
  region = "EU"                        # Valid regions are US and EU
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = var.region
}