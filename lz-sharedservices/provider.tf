# Provider for Shared Services
provider "aws" {
  region = var.region_name
  alias  = "sharedservices"
  default_tags {
    tags = var.tags
  }
}

#Provider for Network Account
provider "aws" {
  region = var.region_name
  alias  = "networking"
  shared_config_files = ["./config"]
  profile = "AWSAFTExecution"
  assume_role {
    role_arn = "arn:aws:iam::${data.aws_ssm_parameter.network_acc_number.value}:role/AWSAFTExecution"
  }
  default_tags {
    tags = var.tags
  }
}

terraform {
  backend "s3" {
    bucket         = "abc-prod-ss-infra-aft-tfstate-ap-northeast-1-000123456789"
    key            = "02-shared-services/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "abc-prod-ss-infra-aft-tf-state-lock"
    encrypt        = true
  }
}