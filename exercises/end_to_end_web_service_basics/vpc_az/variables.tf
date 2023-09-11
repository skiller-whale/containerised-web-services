variable "vpc_id" {
    type = string
}

variable "availability_zone" {
    type = string
}

variable "public_route_table_id" {
    type = string
}
variable "private_route_table_id" {
    type = string
}

variable "public_subnet_cidr" {
    type = string
}

variable "private_subnet_cidr" {
    type = string
}

variable "nat_gateway" {
    description = "Whether to create a NAT Gateway"
    default = true
    type = bool
}
