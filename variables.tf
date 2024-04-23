variable "public_subnet_ids" {
  type = list(string)
  # Replace with the actual IDs of your public subnets
  default = [
    "aws_subnet.Beanstalk-Public-Subnet1.id",
    "aws_subnet.Beanstalk-Public-Subnet2.id"
  ]
}
