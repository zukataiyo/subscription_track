variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.small"
}

variable "app_port" {
  description = "Application HTTP service port"
  type        = number
  default     = 8080
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}
