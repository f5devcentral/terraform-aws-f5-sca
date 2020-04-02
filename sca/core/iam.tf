# 
# Get current AWS region
#
data "aws_region" "current" {}

#
# Get caller identity
#
data "aws_caller_identity" "current" {}

#
# Create IAM Role
#
data "aws_iam_policy_document" "bigip_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bigip_role" {
  name               = format("%s-bigip-role-%s", var.project, random_id.id.hex)
  assume_role_policy = data.aws_iam_policy_document.bigip_role.json

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "bigip_profile" {
  name = format("%s-bigip-profile-%s", var.project, random_id.id.hex)
  role = aws_iam_role.bigip_role.name
}

data "aws_iam_policy_document" "bigip_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      module.core.secrets_manager_id
    ]
  }
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeAddresses",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeNetworkInterfaceAttribute",
      "ec2:DescribeRouteTables",
      "s3:ListAllMyBuckets",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateRoute",
      "ec2:ReplaceRoute"
    ]
    # resources = [format("arn:aws:ec2:%s:%s:route-table/%s",
    #   data.aws_region.current.name,
    #   data.aws_caller_identity.current.account_id,
    #   var.cfe_route_table_id
    # )]
    resources = ["*"]
    # condition {
    #   test     = "StringEquals"
    #   variable = "ec2:ResourceTag/Name"
    #   values   = [var.cfe_ec2_resource_tag]
    # }
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketTagging"
    ]
    # resources = [format("arn:aws:s3:::%s", var.cfe_route_table_id)]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    # resources = [format("arn:aws:s3:::%s/*", var.cfe_route_table_id)]
    resources = ["*"]
  }
  statement {
    actions   = ["logs:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "bigip_policy" {
  name   = format("%s-bigip-policy-%s", var.project, random_id.id.hex)
  role   = aws_iam_role.bigip_role.id
  policy = data.aws_iam_policy_document.bigip_policy.json
}
