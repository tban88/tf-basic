variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile"
  default     = "default"
}

variable "key_name" {
    type = string
    description = "key-pair name"
}

variable "pub_key_path" {
    type = string
    description = "Public key path"
}