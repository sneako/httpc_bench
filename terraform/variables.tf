variable "aws_region" {
  default = "us-east-1"
}

variable "client_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "c5.4xlarge"
}

variable "server_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "c5.4xlarge"
}

variable "ssh_key_name" {
  description = "Name of the ssh key pair to put on the instances"
  type        = string
}

variable "erlang_version" {
  type    = string
  default = "22.2.8"
}

variable "elixir_version" {
  type    = string
  default = "1.10.2-otp-22"
}

variable "request_path" {
  default = "/wait/10"
}

variable "request_method" {
  description = "HTTP method to test, currently only GET & POST are supported"
  default = "get"
}
