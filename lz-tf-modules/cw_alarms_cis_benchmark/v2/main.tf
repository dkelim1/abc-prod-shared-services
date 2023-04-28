resource "aws_sns_topic" "cw_alarms_sns_topic" {
  #checkov:skip=CKV_AWS_26:KMS not enabled
  name = "${var.master_prefix}-lz-cw-alarms-topic"
  tags = var.tags
     provider          = aws.sharedservices
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.cw_alarms_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.function.arn
     provider          = aws.sharedservices
}

resource "aws_lambda_permission" "cw_alarms_topic_lambda_permissions" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cw_alarms_sns_topic.arn
     provider          = aws.sharedservices
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda_source/format_cw_alarms.py"
  output_path = "${path.module}/lambda_source/format_cw_alarms.zip"
}

resource "aws_lambda_function" "function" {
  #checkov:skip=CKV_AWS_50:X-Ray Tracing is not enabled
  #checkov:skip=CKV_AWS_117:Lambda is not configured under VPC
  #checkov:skip=CKV_AWS_116:DLQ is not enabled
  #checkov:skip=CKV_AWS_173:KMS is not enabled
  #checkov:skip=CKV_AWS_115:Project Level Concurrency is not enabled
  #checkov:skip=CKV_AWS_272:code-signing validation is disabled
  filename         = "${path.module}/lambda_source/format_cw_alarms.zip"
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  function_name    = "${var.master_prefix}-lz-format-cw-alarms"
  description      = "Formats a given CloudWatch Alarm to be published to an SNS topic"
  role             = var.iam_lambda_role_arn
  handler          = "format_cw_alarms.lambda_handler"
  timeout          = 120
  runtime          = "python3.8"
  tags             = var.tags
  # reserved_concurrent_executions = 0
  environment {
    variables = {
      sns_topic_arn = var.sns_topic_arn
    }
  }
     provider          = aws.sharedservices
}

resource "aws_cloudwatch_log_group" "lambda_cw_lg" {
  #checkov:skip=  CKV_AWS_158:KMS is not enabled
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
     provider          = aws.sharedservices
}
