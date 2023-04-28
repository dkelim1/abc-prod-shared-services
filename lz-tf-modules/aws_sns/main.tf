# SNS topic to send emails with the Alerts
resource "aws_sns_topic" "alarm_non_prod_hsm" {
  name              = var.topic_name  
  kms_master_key_id = aws_kms_key.sns_key.arn
     provider          = aws.sharedservices
  policy = <<EOF
{
    "Version": "2008-10-17",
  "Statement": [
      {
        "Sid": "__default_statement_ID",
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": "sns:Publish",
        "Resource": "arn:aws:sns:${var.region_name}:${data.aws_caller_identity.current.account_id}:${var.topic_name}"
      }  
  ]
}
EOF
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}
resource "aws_sns_topic_subscription" "email-subscription" {
  topic_arn = aws_sns_topic.alarm_non_prod_hsm.arn
  for_each = toset(var.email_subscriber)
  protocol  = "email"
  endpoint  = each.key
     provider          = aws.sharedservices
  
}

## KMS Key to encrypt the SNS topic (security best practises)

resource "aws_kms_key" "sns_key" {
  description = "SNS Encryption key"
  key_usage   = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  policy =  data.aws_iam_policy_document.sns_key_policy.json
     provider          = aws.sharedservices
}
resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/sns-key-alarm"
  target_key_id = aws_kms_key.sns_key.key_id
     provider          = aws.sharedservices
}