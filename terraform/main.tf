provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "default" {
  name = "httpc_bench_security_group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "client" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]
  key_name               = var.ssh_key_name

  user_data = templatefile("${path.module}/user_data.sh", {
    erlang_version = var.erlang_version
    elixir_version = var.elixir_version
    server_host = aws_instance.server.public_ip
  })

  tags = {
    Name = "httpc_bench_client"
  }
}


resource "aws_instance" "server" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]
  key_name               = var.ssh_key_name

  user_data = templatefile("${path.module}/user_data.sh", {
    erlang_version = var.erlang_version
    elixir_version = var.elixir_version
    server_host = ""
  })

  tags = {
    Name = "httpc_bench_server"
  }
}

output "client_public_ip" {
  value = aws_instance.client.public_ip
}

output "server_public_ip" {
  value = aws_instance.server.public_ip
}
