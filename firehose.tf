resource "aws_kinesis_firehose_delivery_stream" "newrelic_firehost_stream" {
  name        = "newrelic_firehost_stream"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_newrelic_role.arn
    bucket_arn         = aws_s3_bucket.newrelic_aws_bucket.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = var.NEW_RELIC_CLOUDWATCH_ENDPOINT
    name               = "New Relic"
    access_key         = newrelic_api_access_key.newrelic_aws_access_key.key
    buffering_size     = 1
    buffering_interval = 60
    role_arn           = aws_iam_role.firehose_newrelic_role.arn
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }
  }
}