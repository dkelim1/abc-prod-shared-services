#### main.tf

variable "budget_name" {
  description = "The name of a budget. Unique within accounts."
  type        = string
}

variable "budget_type" {
  description = "Whether this budget tracks monetary cost or usage."
  type        = string
}

variable "limit_amount" {
  description = "The amount of cost or usage being measured for a budget."
  type        = string
}

variable "limit_unit" {
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB."
  type        = string
  default     = "USD"
}

variable "time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend."
  type        = string
  default     = "MONTHLY"
}

variable "topic_name" {
  description = " The name of the topic."
  type        = string
  default     = "budget_alerts"
}

variable "region_name" {
  type = string
}

variable "budgets_subscription_email" {
  description = "The email address that will be subscribed to the Budgets Alert topic wihin the account"
  type        = string
}

variable "kms_key_id" {
  type = string
}