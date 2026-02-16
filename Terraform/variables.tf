variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

//subnet details
variable "subnet1" {
  description = "subnet 1 id"
  type        = string
}

variable "subnet2" {
  description = "subnet 2 id"
  type        = string
}

variable "subnet3" {
  description = "subnet 3 id"
  type        = string
}

variable "vpc" {
  description = "vpc id"
  type        = string
}

variable "repo_name" {
  description = "Repository name (used as subdomain prefix)"
  type        = string
}

variable "domain" {
  description = "Base domain name"
  type        = string
}
