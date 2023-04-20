resource "aws_iam_role" "metric_stream_to_firehose" {
  name = "metric_stream_to_firehose_role"

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
resource "aws_cloudwatch_metric_stream" "newrelic_metric_stream" {
  name          = "newrelic-metric-stream"
  role_arn      = aws_iam_role.metric_stream_to_firehose.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_firehost_stream.arn
  output_format = "opentelemetry0.7"
}

resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_pull" {
  account_id = var.NEW_RELIC_ACCOUNT_ID
  arn = aws_iam_role.newrelic_aws_role.arn
  metric_collection_mode = "PULL"
  name = "${var.NEW_RELIC_ACCOUNT_NAME} Pull"
  depends_on = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}