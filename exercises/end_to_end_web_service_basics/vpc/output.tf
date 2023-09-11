output "private_subnet_ids" {
  value = [
    module.az-1.private_subnet_id,
    module.az-2.private_subnet_id
  ]
}

output "public_subnet_ids" {
  value = [
    module.az-1.public_subnet_id,
    module.az-2.public_subnet_id
  ]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
