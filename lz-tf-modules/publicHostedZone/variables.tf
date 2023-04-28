variable "domainname" {
  type        = string
  description = "domain name"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}