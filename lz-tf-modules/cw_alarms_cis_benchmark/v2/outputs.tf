output "lambda_function_arn" {
  value       = aws_lambda_function.function.arn
  description = "ARN of the function used to format the CloudWatch Alarms event"
}

output "lambda_function_cw_log_group_arn" {
  value       = aws_cloudwatch_log_group.lambda_cw_lg.arn
  description = "ARN of the CloudWatch Log Group used by the Lambda function that formats the CloudWatch Alarms event"
}

output "cw_alarms_sns_topic" {
  description = "The SNS topic to which CloudWatch Alarms will be sent."
  value       = aws_sns_topic.cw_alarms_sns_topic
}