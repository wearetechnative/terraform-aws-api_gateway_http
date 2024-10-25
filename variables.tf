variable "name" {
  description = "Prefix name for DynamoDB. Must be unique within the region."
  type        = string
}

variable "security_groups" {
  description = "Security groups to assign. Inbound ports will be added by the module."
  type = list(string)
}

variable "subnets" {
  description = "Public subnets with an internet gateway for LB traffic."
  type = list(string)
}

variable "lb_listener_arn" {
  description = "Load balancer listener ARN."
  type = string
}

variable "hosted_zone_id" {
  description = "Hosted zone ID is always required to properly link the application to the load balancer."
  type = string
}

variable "kms_key_arn" {
  description = "KMS key to use for encrypting CloudWatch log groups."
  type        = string
}

variable "cors_origins" {
  description = "List of CORS origins allowed."
  type = list(string)
  default = []
}