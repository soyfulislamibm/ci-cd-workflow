output "public_ip" {
  description = "Elastic IP of the application server"
  value       = aws_eip.app.public_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_eip.app.public_ip}:3000"
}