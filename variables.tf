# Provider
###########

variable "aws_region" {
  description = "The region for the application evnironment - Default is Frankfurt as our main region"
#  default     = "us-east-1"
}

variable "aws_account_number" {
  description = "The account number used for the environment"
}

# Network
###########

variable "vpc_id" {
  description = "ID of existing VPC which should be used"
  type        = string
}

variable "private_ip" {
  description = "Private IP, which is used for connection"
  type        = string
}
