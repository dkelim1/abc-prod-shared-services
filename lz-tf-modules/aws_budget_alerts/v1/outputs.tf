output "budget" {
  value       = aws_budgets_budget.budget
  description = "The AWS Budgets budget object"
}

output "budget_sns_topic_arn" {
  value       = aws_sns_topic.budgets_topic.arn
  description = "AWS Budgets SNS Topic ARN"
}
