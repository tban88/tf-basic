######################## DATA: VPC ########################

### PROD ###

output "data_prod_vpc_id" {
    value = module.vpc.prod_vpc_data.id
}

### NONPROD ###

output "data_nonprod_vpc_id" {
    value = module.vpc.nonprod_vpc_data.id
}

######################## DATA: SUBNETS ########################

### PROD ###

output "data_prod_prv_subnet_A_id" {
    value = module.vpc.prod_prv_subnet_A_data.id
}

output "data_prod_prv_subnet_B_id" {
    value = module.vpc.prod_prv_subnet_B_data.id
}

output "data_prod_pub_subnet_A_id" {
    value = module.vpc.prod_pub_subnet_A_data.id
}

output "data_prod_pub_subnet_B_id" {
    value = module.vpc.prod_pub_subnet_B_data.id
}

### NONPROD ###

output "data_nonprod_prv_subnet_A_id" {
    value = module.vpc.nonprod_prv_subnet_A_data.id
}

output "data_nonprod_prv_subnet_B_id" {
    value = module.vpc.nonprod_prv_subnet_B_data.id
}

output "data_nonprod_pub_subnet_A_id" {
    value = module.vpc.nonprod_pub_subnet_A_data.id
}

output "data_nonprod_pub_subnet_B_id" {
    value = module.vpc.nonprod_pub_subnet_B_data.id
}

######################## DATA: SECURITY GROUPS ########################

### PROD ###

output "data_prod_df_sg_id" {
    value = module.vpc.prod_df_sg_data.id
}

### NONPROD ###

output "data_nonprod_df_sg_id" {
    value = module.vpc.nonprod_df_sg_data.id
}

######################## DATA: ELB ########################

output "jenkins_target_group_arn" {
    value = module.alb.jenkins_tg_arn
}

output "prod_alb_public_arn" {
    value = module.alb.prod_alb_public_arn
}

output "prod_alb_public_dns" {
    value = module.alb.alb_dns_prod_public
}
/*
output "TEST-OUT" {
    value = data.aws_subnet.data_prod_pub_subnet_A_id.id
}
*/