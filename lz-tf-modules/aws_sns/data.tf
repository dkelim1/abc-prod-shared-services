# Copyright © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved. This AWS Content is provided subject to the terms of the AWS Customer Agreement available at http://aws.amazon.com/agreement or other written agreement between Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both."

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "sns_key_policy" {
  statement {
    sid       = "Enable_IAM_root_permissions"
    effect    = "Allow"
    resources = ["arn:aws:kms:ap-southeast-1:${data.aws_caller_identity.current.account_id}:key/*"]
    actions   = [
      "kms:*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow_CloudWatch_for_CMK"
    effect    = "Allow"
    resources = ["arn:aws:kms:ap-southeast-1:${data.aws_caller_identity.current.account_id}:key/*"]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
}
