# Creating VPC here
resource "aws_vpc" "mainvpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Creating Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.mainvpc.id
}
# Creating Public Subnets
resource "aws_subnet" "publicsubnet" {
  
  for_each          = var.publicsubnets
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = tolist(each.value)[1]
  availability_zone = tolist(each.value)[2]
  tags = {
    Name = tolist(each.value)[0]
  }
}

# Creating Private App Subnets 
resource "aws_subnet" "appsubnets" {
  for_each          = var.appsubnets
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = tolist(each.value)[1]
  availability_zone = tolist(each.value)[2]
  tags = {
    Name = tolist(each.value)[0]
  }
}

# Creating Private DB Subnets 
resource "aws_subnet" "dbsubnets" {
  for_each          = var.dbsubnets
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = tolist(each.value)[1]
  availability_zone = tolist(each.value)[2]
  tags = {
    Name = tolist(each.value)[0]
  }
}
