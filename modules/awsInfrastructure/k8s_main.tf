/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used 
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables 
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs. 

*/
###############################################################################################################################################################################################################################################################

################################################################################################################################################################################################################################################################
#
#  container VPC Creation
#
################################################################################################################################################################################################################################################################
resource "aws_vpc" "container-test" {
  cidr_block           = var.cidr-3
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}_Container-VPC"
  }
}

#Conatiner-test VPC Subnets AZ 1

resource "aws_subnet" "container_subnet_internet_region-az-1" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 0)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-1

  tags = {
    Name = "${var.project}_container_subnet_internet_region-az-1"
  }
}

resource "aws_subnet" "container_subnet_dmz_1_region-az-1" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 1)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-1

  tags = {
    Name = "${var.project}_container_subnet_dmz_1_region-az-1"
  }
}

resource "aws_subnet" "container_subnet_application_region-az-1" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 2)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-1

  tags = {
    Name = "${var.project}_container_subnet_application_region-az-1"
  }
}

resource "aws_subnet" "container_subnet_peering_region-az-1" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 3)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-1

  tags = {
    Name = "${var.project}_container_subnet_peering_region-az-1"
  }
}

resource "aws_subnet" "container_subnet_mgmt_region-az-1" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 100)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-1

  tags = {
    Name = "${var.project}_container_subnet_mgmt_region-az-1"
  }
}

#container-Test Subnets AZ 2

resource "aws_subnet" "container_subnet_internet_region-az-2" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 10)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-2

  tags = {
    Name = "${var.project}_container_subnet_internet_region-az-2"
  }
}

resource "aws_subnet" "container_subnet_dmz_1_region-az-2" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 11)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-2

  tags = {
    Name = "${var.project}_container_subnet_dmz_1_region-az-2"
  }
}

resource "aws_subnet" "container_subnet_application_region-az-2" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 12)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-2

  tags = {
    Name = "${var.project}_container_subnet_application_region-az-2"
  }
}

resource "aws_subnet" "container_subnet_peering_region-az-2" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 13)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-2

  tags = {
    Name = "${var.project}_container_subnet_peering_region-az-2"
  }
}

resource "aws_subnet" "container_subnet_mgmt_region-az-2" {
  cidr_block        = cidrsubnet(aws_vpc.container-test.cidr_block, 8, 200)
  vpc_id            = aws_vpc.container-test.id
  availability_zone = var.region-az-2

  tags = {
    Name = "${var.project}_container_subnet_mgmt_region-az-2"
  }
}

/*
CREATE container-Test Main RT
*/

resource "aws_route_table" "container_tgw_main_rt" {
  vpc_id = aws_vpc.container-test.id

  tags = {
    Name = "${var.project}_container_main_rt"
  }
}

#Associate Conatiner Subnets with Main_RT

resource "aws_route_table_association" "container_subnet_internet_region-az-1" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_internet_region-az-1.id
}

resource "aws_route_table_association" "container_subnet_dmz_1_region-az-1" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_dmz_1_region-az-1.id
}

resource "aws_route_table_association" "container_subnet_application_region-az-1" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_application_region-az-1.id
}

resource "aws_route_table_association" "container_subnet_peering_region-az-1" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_peering_region-az-1.id
}

resource "aws_route_table_association" "container_subnet_mgmt_region-az-1" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_mgmt_region-az-1.id
}

resource "aws_route_table_association" "container_subnet_internet_region-az-2" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_internet_region-az-2.id
}

resource "aws_route_table_association" "container_subnet_dmz_1_region-az-2" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_dmz_1_region-az-2.id
}

resource "aws_route_table_association" "container_subnet_application_region-az-2" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_application_region-az-2.id
}

resource "aws_route_table_association" "container_subnet_peering_region-az-2" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_peering_region-az-2.id
}

resource "aws_route_table_association" "container_subnet_mgmt_region-az-2" {
  route_table_id = aws_route_table.container_tgw_main_rt.id
  subnet_id      = aws_subnet.container_subnet_mgmt_region-az-2.id
}

#Enpoint Security Group

resource "aws_security_group" "sg_internal_container_vpc" {
  description = "wide open"
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.cidr-3}"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.cidr-3}"]
  }
  vpc_id = aws_vpc.container-test.id
}


# Create S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3-container-vpc" {
  vpc_id       = aws_vpc.container-test.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3-container-vpc" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-container-vpc.id
  route_table_id  = aws_route_table.container_tgw_main_rt.id
}


# Create EC2 VPC Endpoint
resource "aws_vpc_endpoint" "conatiner-ec2-endpoint" {
  vpc_id            = aws_vpc.container-test.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.sg_internal_container_vpc.id]

  private_dns_enabled = true
  subnet_ids          = [aws_subnet.container_subnet_peering_region-az-1.id, aws_subnet.container_subnet_peering_region-az-2.id]
}

# Create Cloudwatch VPC Endpoint
resource "aws_vpc_endpoint" "container-vpc-logs" {
  vpc_id            = aws_vpc.container-test.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.sg_internal_container_vpc.id]

  private_dns_enabled = true
  subnet_ids          = [aws_subnet.container_subnet_peering_region-az-1.id, aws_subnet.container_subnet_peering_region-az-2.id]

}


