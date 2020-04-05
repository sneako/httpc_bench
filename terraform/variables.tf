variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "c5.4xlarge"
}

variable "ssh_key_name" {
  description = "Name of the ssh key pair to put on the instances"
  type        = string
}

