output "aws_public_subnet" {
  value = aws_subnet.public_pravinjob_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.pravinjob.id
}