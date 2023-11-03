output "vpc_id" {
  value = aws_vpc.default.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.default.id
}