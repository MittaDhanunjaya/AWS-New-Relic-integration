data "aws_iam_role" "firehose_newrelic_role"{
  name = "firehose_newrelic_role"
}
output "role_exists_fh"{
  value = data.aws_iam_role.firehose_newrelic_role.id != null
}
data "aws_iam_role" "metric_stream_to_firehose"{
  name = "metric_stream_to_firehose_role"
}
resource "aws_iam_role" "firehose_newrelic_role" {
  name = "firehose_newrelic_role"
  count = var.create_role_fh && !data.aws_iam_role.firehose_newrelic_role.id != null ? 1 : 0

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_kinesis_firehose_delivery_stream" "newrelic_firehost_stream"{
  name = "newrelic_firehose_stream"
}

resource "aws_kinesis_firehose_delivery_stream" "newrelic_firehost_stream" {
  name        = "newrelic_firehose_stream"
  count = var.create_kinesis_firehose_ds && !data.aws_kinesis_firehose_delivery_stream.newrelic_firehost_stream.id != null ? 1 : 0
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_newrelic_role[count.index].arn
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
    role_arn           = aws_iam_role.firehose_newrelic_role[count.index].arn
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }
  }
}

resource "aws_iam_role" "metric_stream_to_firehose" {
  name = "metric_stream_to_firehose_role"
  count = var.create_role && !data.aws_iam_role.metric_stream_to_firehose.id != null ? 1 : 0


  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "streams.metrics.cloudwatch.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "metric_stream_to_firehose" {
  name = "default"
  role = aws_iam_role.metric_stream_to_firehose.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": "${aws_kinesis_firehose_delivery_stream.newrelic_firehost_stream.arn}"
        }
    ]
}
EOF
}