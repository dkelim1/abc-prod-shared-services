output "hsm_sns_topic_arn" {
  value       = aws_sns_topic.alarm_non_prod_hsm.arn
  description = "AWS HAM SNS Topic ARN"
}
