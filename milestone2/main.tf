# Creating VPC here
resource "aws_vpc" "mainvpc" {

  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
}

# Creating Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.mainvpc.id
}
# Creating Public Subnets
resource "aws_subnet" "publicsubnets" {
  count             = length(var.publicsubnets)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.publicsubnets[count.index]
  availability_zone = var.availability_zones[count.index]

}

# Creating Private App Subnets
resource "aws_subnet" "appsubnets" {
  count             = length(var.appsubnets)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.appsubnets[count.index]
  availability_zone = var.availability_zones[count.index]
}

# Creating Private DBA Subnets
resource "aws_subnet" "dbasubnets" {
  count             = length(var.dbasubnets)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.dbasubnets[count.index]
  availability_zone = var.availability_zones[count.index]
}
# Creating RT for Public Subnets
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  count          = length(aws_subnet.publicsubnets)
  subnet_id      = aws_subnet.publicsubnets[count.index].id
  route_table_id = aws_route_table.PublicRT.id
}


resource "aws_eip" "natips" {
  count = length(var.availability_zones)
  vpc   = true
}

resource "aws_nat_gateway" "NATgws" {
  count         = length(var.availability_zones)
  subnet_id     = aws_subnet.publicsubnets[count.index].id
  allocation_id = aws_eip.natips[count.index].id
}

# Creating RT for Private Subnets
resource "aws_route_table" "PrivateRT" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgws[count.index].id
  }
}

resource "aws_route_table_association" "PrivateRTassociationdba" {
  count          = length(var.dbasubnets)
  subnet_id      = aws_subnet.dbasubnets[count.index].id
  route_table_id = aws_route_table.PrivateRT[count.index].id
}

resource "aws_route_table_association" "PrivateRTassociationapp" {
  count          = length(var.appsubnets)
  subnet_id      = aws_subnet.appsubnets[count.index].id
  route_table_id = aws_route_table.PrivateRT[count.index].id
}