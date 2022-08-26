######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

/*
REQUIRED PARAMETERS 
sg_name
sg_description
vpc_id
ingress_object_rules (description, from_port, to_port, protocol, cidr_blocks)

OPTIONAL: DEFAULT
egress_object_rules (description, from_port, to_port, protocol, cidr_blocks)
*/

resource "aws_security_group" "new_sg" {
  name = "${upper(var.sg_name)}"
  description = var.sg_description
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${upper(var.sg_name)}"
  }

  dynamic "ingress" {
    for_each = var.ingress_object_rules
    iterator = ingress 

    content {
        description = ingress.value.description
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = ingress.value.protocol
        cidr_blocks = ["${ingress.value.cidr_blocks}"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_object_rules
    iterator = egress

    content {
        from_port = egress.value.port
        to_port = egress.value.port
        protocol = egress.value.protocol
        cidr_blocks = ["${egress.value.cidr_blocks}"]
        ipv6_cidr_blocks = ["::/0"]      
    }
  }
}