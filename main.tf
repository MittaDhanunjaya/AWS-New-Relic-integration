terraform {
  required_version = ">= 1.1.5"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.44"  # Update this line
    }
  }
}

provider "newrelic" {
  region = "EU"                        # Valid regions are US and EU
}

provider "aws"{
  region = var.region
  version = "4.8.0"
}