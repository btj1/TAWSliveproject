variable "region" {
  type        = string
  default     = "us-west-1"
  description = "Region to deploy the Stack in"

}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b", "us-west-1c"]
  description = "List of AZs to use. needs to be adjusted when Region is changed"
}

variable "publicsubnets" {
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  description = "CIDRs for the public subnets, note that the nr of subnets determines the nr. of EIPs and NAT_GWs as well"
}
variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "CIDR Range to use for the VPC"
}

variable "dbasubnets" {
  type        = list(string)
  default     = ["172.16.8.0/24", "172.16.9.0/24", "172.16.10.0/24"]
  description = "CIDRs for the private DBA subnets"
}
variable "appsubnets" {
  type        = list(string)
  default     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  description = "CIDRs for the privat App subnets"
}



