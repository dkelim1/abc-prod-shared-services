# Copyright © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved. This AWS Content is provided subject to the terms of the AWS Customer Agreement available at http://aws.amazon.com/agreement or other written agreement between Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both."

#------------------------------------------------------------------------------
# Common Variables across all modules
#------------------------------------------------------------------------------


variable "region_name" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-1"
}
variable "email_subscriber" {
  type    = list(string)
//  default = [""]
}
 variable "topic_name" {
  description = " The name of the topic."
  type        = string
  default     = "hsm_non_prod_alerts"
}


