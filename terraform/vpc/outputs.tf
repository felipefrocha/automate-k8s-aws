output "out_vpc_main_arn" {
  value = aws_vpc.main.arn
}

output "out_puplic_subnets_id" {
  value = aws_subnet.publics.*.id
}

output "out_vpc_id" {
  value = aws_vpc.main.id
}

output "out_ami" {
  value = data.aws_ami.this
}

output "out_file" {
  value = local_file.vpc_info.filename
}