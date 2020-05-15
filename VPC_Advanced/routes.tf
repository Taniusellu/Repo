# resource "aws_subnet" "public" {
#     count                    = "${length(var.availability_zones)}"
#     vpc_id                   = "${aws_vpc.main.id}"
#     cidr_block               = "${cidrsubnet(var.cidr_block, 8, count.index)}"
#     availability_zone        = "${element(var.availability_zones, count.index)}"
#     map_public_ip_on_launch  = true

#     tags = {
#     "Name" = "Public_subnet - ${element(var.availability_zones, count.index)}"
# }
# }

# resource "aws_nat_gateway" "main" {
  
#   count                  = "${length(var.availability_zones)}"
#   subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
#   allocation_id          = "${element(aws_eip.nat.*.id, count.indez)}"

#   tags = {
#       "Name" = "NAT - ${element(var.availability_zones, count.index)}"
#   }
# }

# resource "aws_route_table" "public" {
#     vpc_id = "${aws_vpc.main.id}"

#     tags = {
#         "Name" = "Public route table"
#     }
  
# }

# resource "aws_rout" "public_internet_gateway" {
#     route_table_id         = "${aws_route_table.public.id}"
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id             = "${aws_internet_gateway.main.id}"
  
# }

# resource "aws_route_table_association" "public" {
#     count       = "${length(var.availability_zones)}"

#     subnet_id   = "${element(aws_subnet.public.*.id, count.index)}"
#     route_table_id  = "${aws_route_table.public.id}"
# }

# resource "aws_autoscaling_group" "bastion" {
#     name = "${aws_launch_configuration.bastion.name}-asg"

#     min_size              = 0
#     desired_capacity      = 1
#     max_size              = 1
#     health_check_type     = "EC2"
#     launch_configuration  = "${aws_launch_configuration.bastion.name}"
#     vpc_zone_identifier   = ["${aws_subnet.public.*.id}"]

#    tags = [{
#        key    = "Name"
#        value  = "Bastion"
#        propagate_at_launch = true

#    },

#    ]
#    lifecycle {
#        create_before_destroy  = true
#    }
# }



# output "vpc_id" {
#   value = "${aws_vpc.main.id}"
# }


# output "public_subnets" {
#   value = "${aws_subnets.public.*.id}"
# }


# output "public_cidrs" {
#   value = "${aws_subnet.public.*.cidr_block}"
# }


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Public route table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "application" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Application route table - ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "database" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Database route table - ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route" "application_gateway" {
  count = "${length(var.availability_zones)}"

  route_table_id         = "${element(aws_route_table.application.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}
resource "aws_route" "database_gateway" {
  count = "${length(var.availability_zones)}"

  route_table_id         = "${element(aws_route_table.database.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

resource "aws_route_table_association" "application" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.application.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.application.*.id, count.index)}"
}
resource "aws_route_table_association" "database" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.database.*.id, count.index)}"


}