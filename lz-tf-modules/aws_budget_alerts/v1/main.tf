
#############################################################################
#  Budgets
#############################################################################
resource "aws_budgets_budget" "budget" {
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = format("%.1f", var.limit_amount)
  limit_unit        = var.limit_unit
  time_period_start = formatdate("YYYY-MM-01_00:00", timestamp())
  time_unit         = var.time_unit
   provider          = aws.sharedservices

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 50
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_topic.arn]
  }


  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_topic.arn]
  }


  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_topic.arn]
  }

  lifecycle {
    ignore_changes = [
      time_period_start
    ]
  }
}

#############################################################################
#  SNS Topic
#############################################################################
data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "budgets_topic" {
  #checkov:skip=CKV_AWS_26:KMS not enabled
  name   = var.topic_name
  policy = data.aws_iam_policy_document.sns_topic_policy.json
  kms_master_key_id = var.kms_key_id
   provider          = aws.sharedservices
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      "arn:aws:sns:${var.region_name}:${data.aws_caller_identity.current.account_id}:${var.topic_name}"
    ]

    sid = "AWSBudgetsSNSPublishingPermissions"
  }
}

#############################################################################
#  SNS Subscription
#############################################################################

resource "aws_sns_topic_subscription" "budgets_email_subscription" {
  topic_arn = aws_sns_topic.budgets_topic.arn
  protocol  = "email"
  endpoint  = var.budgets_subscription_email
   provider          = aws.sharedservices
}