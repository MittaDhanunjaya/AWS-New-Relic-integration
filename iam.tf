data "aws_iam_role" "newrelic_aws_role"{
  name = "NewRelicInfrastructure-Integrations"
}
output "role_exists"{
  value = data.aws_iam_role.newrelic_aws_role.id != null
}
resource "aws_iam_role" "newrelic_aws_role" {
  count = var.create_role && !data.aws_iam_role.newrelic_aws_role.id != null ? 1 : 0
  name               = "NewRelicInfrastructure-Integrations"
  description        = "New Relic Cloud integration role"
  #only creates the role if it doesn't already exists
  assume_role_policy = data.aws_iam_policy_document.newrelic_assume_policy.json
}

resource "aws_iam_policy" "newrelic_aws_permissions" {
  name        = "NewRelicCloudStreamReadPermissions"
  description = ""
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "budgets:ViewBudget",
        "cloudtrail:LookupEvents",
        "config:BatchGetResourceConfig",
        "config:ListDiscoveredResources",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeNatGateways",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeSubnets",
        "ec2:DescribeNetworkAcls",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeVpnConnections",
        "health:DescribeAffectedEntities",
        "health:DescribeEventDetails",
        "health:DescribeEvents",
        "tag:GetResources",
        "xray:BatchGet*",
        "xray:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "newrelic_aws_policy_attach" {
  count = data.aws_iam_role.newrelic_aws_role.id != null ? 1 : 0
  role       = aws_iam_role.newrelic_aws_role[count.index].name
  policy_arn = aws_iam_policy.newrelic_aws_permissions.arn
  #only attach the policy if the role already exists

}