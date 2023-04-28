
resource "aws_lambda_permission" "config_event_lambda_permissions" {
  statement_id  = "AllowExecutionFromCWEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
   provider          = aws.sharedservices
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda_source/format_config_compliance_alerts.py"
  output_path = "${path.module}/lambda_source/format_config_compliance_alerts.zip"
}

resource "aws_lambda_function" "function" {
  #checkov:skip=CKV_AWS_50:X-Ray Tracing is not enabled
  #checkov:skip=CKV_AWS_117:Lambda is not configured under VPC
  #checkov:skip=CKV_AWS_116:DLQ is not enabled
  #checkov:skip=CKV_AWS_173:KMS is not enabled
  #checkov:skip=CKV_AWS_115:Project Level Concurrency is not enabled
  #checkov:skip=CKV_AWS_272:code-signing validation is disabled
  filename         = "${path.module}/lambda_source/format_config_compliance_alerts.zip"
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  function_name    = "${var.master_prefix}-lz-format-config-compliance-alerts"
  description      = "Function to process event generated by AWS Config Rules compliance status change"
  role             = var.iam_lambda_role_arn
  handler          = "format_config_compliance_alerts.lambda_handler"
  timeout          = 120
  runtime          = "python3.8"
  tags             = var.tags
   provider          = aws.sharedservices
  #reserved_concurrent_executions = 0
  environment {
    variables = {
      sns_topic_arn = var.sns_topic_arn
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_cw_lg" {
  #checkov:skip=  CKV_AWS_158:KMS is not enabled
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
  tags              = var.tags
   provider          = aws.sharedservices
}

resource "aws_cloudwatch_event_rule" "compliance_change_event" {
   provider          = aws.sharedservices
  name          = "${var.master_prefix}-${var.env_prefix}-${var.app_prefix}-config-compliance-status-event-rule"
  description   = "CloudWatch Event Rule to send notification on Config Rule compliance changes."
  tags          = var.tags
  event_pattern = <<EOT
{
  "detail-type": [
    "Config Rules Compliance Change"
  ],
  "source": [
    "aws.config"
  ],
  "detail": {
    "messageType": [
      "ComplianceChangeNotification"
    ],
    "newEvaluationResult": {
      "complianceType": [
        "NON_COMPLIANT"
      ]
    }
  }
}
  EOT
}

resource "aws_cloudwatch_event_target" "event_target" {
   provider          = aws.sharedservices
  target_id = "config-compliance-change-event-handler"
  rule      = aws_cloudwatch_event_rule.compliance_change_event.name
  arn       = aws_lambda_function.function.arn
}
