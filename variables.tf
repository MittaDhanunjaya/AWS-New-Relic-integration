variable "aws_resource_prefix" {
  description = "Prefix for the AWS Resources"
}

variable "NEW_RELIC_ACCOUNT_ID" {
  type = string
}

variable "NEW_RELIC_ACCOUNT_NAME" {
  description = "Account Name"
}

variable "NEW_RELIC_CLOUDWATCH_ENDPOINT" {
  type = string
  # Depending on where your New Relic Account is located you need to change the default
  #default = "https://aws-api.newrelic.com/cloudwatch-metrics/v1" # US Datacenter
  default = "https://aws-api.eu01.nr-data.net/cloudwatch-metrics/v1" # EU Datacenter
}