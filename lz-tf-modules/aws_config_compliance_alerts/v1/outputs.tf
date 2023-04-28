output "lambda_function_arn" {
  value       = aws_lambda_function.function.arn
  description = "ARN of the function used to format the AWS Config Compliance event"
}

output "lambda_function_cw_log_group_arn" {
  value       = aws_cloudwatch_log_group.lambda_cw_lg.arn
  description = "ARN of the CloudWatch Log Group used by the Lambda function that formats the AWS Config Compliance event"
}

output "config_event_rule_arn" {
  value       = aws_cloudwatch_event_rule.compliance_change_event.arn
  description = "ARN of the EventBridge Event Rule to detect AWS Config compliance change"
}
