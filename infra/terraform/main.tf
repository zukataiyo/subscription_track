# Security Group for Taskflow API Host
resource "aws_security_group" "app_sg" {
  name        = "taskflow-app-sg"
  description = "Controls ingress and egress traffic for taskflow application instance"

  # INGRESS RULE: Restrict port 8080 to internal VPC CIDR (Fix for tfsec AWS008 / checkov CKV_AWS_24)
  ingress {
    description = "Allow inbound HTTP application traffic on port 8080 from internal VPC"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Allow administrative SSH ingress from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    description = "Allow all outbound HTTPS traffic for updates and container pulls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "taskflow-app-sg"
  }
}

# EC2 Compute Instance
resource "aws_instance" "app" {
  ami           = "ami-0df7a207adb9748c7" # Amazon Linux 2023 LTS
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Root block device with KMS encryption enabled (Fix for tfsec AWS014 / checkov CKV_AWS_8)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true
  }

  # Enforce IMDSv2 tokens (Fix for checkov CKV_AWS_79)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "taskflow-api-host"
  }
}
