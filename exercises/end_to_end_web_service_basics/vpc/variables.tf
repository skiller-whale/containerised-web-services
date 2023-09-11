variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
    description = "CIDR for Public Subnet 1"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr_2" {
    description = "CIDR for Public Subnet 2"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_1" {
    description = "CIDR for Private Subnet 1"
    default = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
    description = "CIDR for the Private Subnet 2"
    default = "10.0.3.0/24"
}
