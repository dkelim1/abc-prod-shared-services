## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.r53_alias_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.phz_vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group.vpc_endpoint_sec_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_prefix | Application Prefix for all AWS Resources | `string` | n/a | yes |
| env\_prefix | Environment Prefix for all AWS Resources | `string` | n/a | yes |
| master\_prefix | Master Prefix for all AWS Resources | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_endpoint\_service\_name | AWS Service name for creating the VPC Endpoint | `string` | n/a | yes |
| vpc\_endpoint\_subnet\_ids | List of subnet ids where the VPC Interface Endpoints will be created | `list(string)` | n/a | yes |
| vpc\_id | VPC ID | `string` | n/a | yes |
| vpc\_tags | Additional tags for VPC resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| r53\_zone\_id | Route 53 Private Hosted Zone Id for the VPC Endpoint |
| vpc\_endpoint\_dns\_entry | DNS Name of the VPC Endpoint |
| vpc\_endpoint\_id | VPC Endpoint Id |
