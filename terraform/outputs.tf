output "ami" {
  value     = aws_instance.master.*.ami
  sensitive = true
}

output "public_ip" {
  value = aws_instance.master.*.public_ip
}

