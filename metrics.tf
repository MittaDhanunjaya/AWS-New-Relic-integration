
resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_push" {
  arn = aws_iam_role.newrelic_aws_role.arn
  metric_collection_mode = "PUSH"
  name = "${var.NEW_RELIC_ACCOUNT_NAME} Push"
  depends_on = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}

