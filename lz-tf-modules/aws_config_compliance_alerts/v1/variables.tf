
variable "sns_topic_arn" {
  description = "The ARN of the SNS Topic which receives formatted messages and has email subscribers"
  default     = ""
}

variable "iam_lambda_role_arn" {
  description = "The ARN of the IAM role to be assumed by Lambda to process events and publish to SNS Topic"
}


variable "tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  default = {
    "Terraform" = true
  }
}

variable "master_prefix" {
  description = "Master Prefix for all AWS Resources"
  type        = string
}

variable "env_prefix" {
  description = "Environment Prefix for all AWS Resources"
  type        = string
}

variable "app_prefix" {
  description = "Application Prefix for all AWS Resources"
  type        = string
}