output "instance_id" {
  description = "ID of the provisioned EC2 instance"
  value       = aws_instance.app.id
}

output "instance_private_ip" {
  description = "Private IP address of the provisioned host"
  value       = aws_instance.app.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the provisioned host"
  value       = aws_instance.app.public_ip
}

output "app_url" {
  description = "Direct HTTP access URL for Taskflow API"
  value       = "http://${aws_instance.app.public_ip}:${var.app_port}"
}
