######################## DATA: VPC ########################

### PROD ###

output "prod_vpc_data" {
  value = data.aws_vpc.prod_vpc_data
}

### NONPROD ###
output "nonprod_vpc_data" {
  value = data.aws_vpc.nonprod_vpc_data
}

######################## DATA: SUBNETS ########################

### PROD ###

output "prod_prv_subnet_A_data" {
  value = data.aws_subnet.prod_prv_subnet_A_data
}

output "prod_prv_subnet_B_data" {
  value = data.aws_subnet.prod_prv_subnet_B_data
}

output "prod_pub_subnet_A_data" {
  value = data.aws_subnet.prod_pub_subnet_A_data
}

output "prod_pub_subnet_B_data" {
  value = data.aws_subnet.prod_pub_subnet_B_data
}

### NONPROD ###

output "nonprod_prv_subnet_A_data" {
  value = data.aws_subnet.nonprod_prv_subnet_A_data
}

output "nonprod_prv_subnet_B_data" {
  value = data.aws_subnet.nonprod_prv_subnet_B_data
}

output "nonprod_pub_subnet_A_data" {
  value = data.aws_subnet.nonprod_pub_subnet_A_data
}

output "nonprod_pub_subnet_B_data" {
  value = data.aws_subnet.nonprod_pub_subnet_B_data
}

######################## DATA: SECURITY GROUPS ########################

### PROD ###

output "prod_df_sg_data" {
  value = data.aws_security_group.prod_df_sg_data
}

### NONPROD ###

output "nonprod_df_sg_data" {
  value = data.aws_security_group.nonprod_df_sg_data
}
