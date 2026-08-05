data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "app" {
  name        = "cicd-app-security-group"
  description = "Allow access to Express application"

  ingress {
    description = "Express application"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = "cicd-dev-key"

  user_data = <<-EOF
  #!/bin/bash
  dnf update -y
  dnf install -y docker

  systemctl enable docker
  systemctl start docker

  usermod -aG docker ec2-user
EOF

  tags = {
    Name        = "cicd-node-app"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}