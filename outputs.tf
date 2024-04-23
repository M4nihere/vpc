output "vpc_id" {
  value = aws_vpc.main.id
}
output "Private_subnet1" {
  value = aws_subnet.Beanstalk-Private-Subnet1.id
}


output "Private_subnet2" {
  value = aws_subnet.Beanstalk-Private-Subnet2.id
}

output "public_subnet_ids" {
  value = aws_subnet.Beanstalk-Public-Subnet1.id
}

