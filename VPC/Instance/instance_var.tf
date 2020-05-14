variable "region" {}
variable "cidr_block" {}

variable "cidr_block1_public" {}
variable "cidr_block2_public" {}
variable "cidr_block3_public" {}

variable "cidr_block1_private" {}
variable "cidr_block2_private" {}
variable "cidr_block3_private" {}

variable "az1" {}
variable "az2" {}
variable "az3" {}

variable "tags" {
  type = "map"
}





variable "name" {
  type = "string"
  default = "instance-name"
}

variable "instance" {
  type = "map"

  default = {
      instance_name                 = "instance"
      instance_ami                  = "ami-0d6621c01e8c2de2c"
      instance_type                 = "t2.micro"
      instance_count                = 3
      instance_key_name             = "bastion_key"
       instance_security_groups      = "allow_tls"
      # instance_user_data            = "fhgffj"
      instance_availability_zone    = "us-west-2a"
      #  tags = "${var.tags}"

  }
}

variable "active" {
  default = "true"
}

# output "Is_VPC_created?" {
#   value = "${var.active == "true" ? "VPC is created" : "Vpc is not created"}"
# }

resource "null_resource" "instance_object" {
  count = "${var.active == "true" ? 1 : 0}"
  provisioner "local-exec" {
    command = <<EOF
        #!/bin/bash
        echo -e '''
        Instance Name:                   "${var.instance["instance_name"]}"
        Instance AMI:                    "${var.instance["instance_ami"]}"
        Instance Type:                   "${var.instance["instance_type"]}"
        Instance Count:                  "${var.instance["instance_count"]}"
        Instance Key_Name:               "${var.instance["instance_key_name"]}"
       
        Instance Availability_zone:      "${var.instance["instance_availability_zone"]}"
        '''
        EOF
  }
}

# Instance User_Data:              "${var.instance["instance_user_data"]}"
#Instance Sec_Group:              "${var.instance["instance_security_group"]}"
