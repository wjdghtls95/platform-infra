provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_key_pair" "github" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "app_sg" {
  name = "app-sg"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { from_port = 3000 to_port = 3000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 8000 to_port = 8000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress {
    from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.github.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = { Name = var.name }
}