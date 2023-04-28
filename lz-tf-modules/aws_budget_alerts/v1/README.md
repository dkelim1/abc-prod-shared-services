Creates an AWS Budgets budget with actual cost and pre-defined thresholds 50%, 80% and 100%. Budget threshold breaches are published to an SNS Topic. An email subscription is set up to this topic.


## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| aws  | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                        | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_budgets_budget.budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget)                                     | resource    |
| [aws_sns_topic.budgets_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                        | resource    |
| [aws_sns_topic_subscription.budgets_email_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                               | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)              | data source |

## Inputs

| Name                         | Description                                                                                                     | Type     | Default           | Required |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------- | -------- | ----------------- | :------: |
| budget\_name                 | The name of a budget. Unique within accounts.                                                                   | `string` | n/a               |   yes    |
| budget\_type                 | Whether this budget tracks monetary cost or usage.                                                              | `string` | n/a               |   yes    |
| budgets\_subscription\_email | The email address that will be subscribed to the Budgets Alert topic wihin the account                          | `string` | n/a               |   yes    |
| limit\_amount                | The amount of cost or usage being measured for a budget.                                                        | `string` | n/a               |   yes    |
| limit\_unit                  | The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB. | `string` | `"USD"`           |    no    |
| region\_name                 | n/a                                                                                                             | `string` | n/a               |   yes    |
| time\_unit                   | The length of time until a budget resets the actual and forecasted spend.                                       | `string` | `"MONTHLY"`       |    no    |
| topic\_name                  | The name of the topic.                                                                                          | `string` | `"budget_alerts"` |    no    |

## Outputs

| Name                    | Description                  |
| ----------------------- | ---------------------------- |
| budget                  | The AWS Budget budget object |
| budget\_sns\_topic\_arn | AWS Budgets SNS Topic ARN    |
