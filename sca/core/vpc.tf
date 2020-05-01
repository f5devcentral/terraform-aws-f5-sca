locals {
  subnets = flatten([
    for subnet_id, subnet in var.subnets : [
      for az in range(var.vpcs[subnet.vpc].num_availability_zones) : {
        name : subnet_id
        vpc : subnet.vpc
        vpc_id : aws_vpc.sca[subnet.vpc].id
        cidr : cidrsubnet(var.vpcs[subnet.vpc].cidr_block, 8, subnet.netnum + az)
        availability_zone       = data.aws_availability_zones.available.names[az]
        map_public_ip_on_launch = subnet.map_public_ip_on_launch
      }
    ]
  ])

  routes = flatten([
    for route_id, route in var.routes : [
      for subnet in route.subnets : [
        for az in range(var.vpcs[var.subnets[subnet].vpc].num_availability_zones) : {
          az : az
          availability_zone : data.aws_availability_zones.available.names[az]
          name : route_id
          subnet : subnet
          vpc : var.subnets[subnet].vpc
          vpc_id : aws_vpc.sca[var.subnets[subnet].vpc].id
        }
      ]
    ]
  ])

  nat_gateways = flatten([
    for nat_gateway_id, nat_gateway in var.nat_gateways : [
      for subnet in nat_gateway.subnets : [
        for az in range(var.vpcs[var.subnets[subnet].vpc].num_availability_zones) : {
          az : az
          availability_zone : data.aws_availability_zones.available.names[az]
          name : nat_gateway_id
          subnet : subnet
          vpc : var.subnets[subnet].vpc
          vpc_id : aws_vpc.sca[var.subnets[subnet].vpc].id
        }
      ]
    ]
  ])

  route_endpoints = flatten([
    for endpoint_id, endpoint in var.route_endpoints : [
      for route in endpoint.routes : {
        endpoint = endpoint_id
        vpc      = endpoint.vpc
        route    = route
      }
    ]
  ])
}

# find availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create the SCA AWS Virtual Private Clouds
resource "aws_vpc" "sca" {
  for_each = {
    for id, vpc in var.vpcs :
    id => vpc
  }

  cidr_block           = each.value.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_%s", var.project, each.key, local.postfix)
    }
  )
}

# Create the VPC Subnets
resource "aws_subnet" "sca" {
  for_each = {
    for subnet in local.subnets : format("%s:%s", subnet.name, subnet.availability_zone) => subnet
  }

  cidr_block              = each.value.cidr
  vpc_id                  = each.value.vpc_id
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_%s", var.project, each.key, local.postfix)
    }
  )
}

# Create the Internet Gateway
resource "aws_internet_gateway" "sca" {
  for_each = {
    for id, vpc in var.vpcs : id => vpc
    if(vpc.internet_gateway == true)
  }
  vpc_id = aws_vpc.sca[each.key].id

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_igw_%s", var.project, each.key, local.postfix)
    }
  )
}

# Create Route Tables
resource "aws_route_table" "sca" {
  for_each = var.routes
  vpc_id   = aws_vpc.sca[each.value.vpc].id

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_rt_%s", var.project, each.key, local.postfix)
    }
  )
}

# Associate Subnets with Internet Gateway Route
resource "aws_route_table_association" "sca" {
  for_each = {
    for route in local.routes : format("%s:%s:%s", route.name, route.subnet, route.availability_zone) => route
  }
  route_table_id = aws_route_table.sca[each.value.name].id
  subnet_id      = aws_subnet.sca[format("%s:%s", each.value.subnet, each.value.availability_zone)].id
}

# Create NAT Gateway Elastic IP
resource "aws_eip" "sca" {
  for_each = {
    for nat_gateway in local.nat_gateways : format("%s:%s:%s", nat_gateway.name, nat_gateway.subnet, nat_gateway.availability_zone) => nat_gateway
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_nat_gw_eip_%s", var.project, each.key, local.postfix)
    }
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "sec-gw" {
  for_each = {
    for nat_gateway in local.nat_gateways : format("%s:%s:%s", nat_gateway.name, nat_gateway.subnet, nat_gateway.availability_zone) => nat_gateway
  }

  allocation_id = aws_eip.sca[each.key].id
  subnet_id     = aws_subnet.sca[format("%s:%s", each.value.subnet, each.value.availability_zone)].id

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_nat_gw_%s", var.project, each.key, local.postfix)
    }
  )
}

# Create Endpoints
resource "aws_vpc_endpoint" "sca" {
  for_each = var.route_endpoints

  vpc_id       = aws_vpc.sca[each.value.vpc].id
  service_name = format("com.amazonaws.%s.%s", var.aws_region, each.key)
}

# TODO: add the subnets
resource "aws_vpc_endpoint" "sca_interface" {
  for_each = var.interface_endpoints

  vpc_id             = aws_vpc.sca[each.value.vpc].id
  service_name       = format("com.amazonaws.%s.%s", var.aws_region, each.key)
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.sg_internal_security_vpc.id]

  private_dns_enabled = true
  // ADD THE SUBNETS
  subnet_ids = []
}

# Associate endpoint to route table
resource "aws_vpc_endpoint_route_table_association" "sca" {
  for_each = {
    for endpoint in local.route_endpoints : format("%s:%s", endpoint.endpoint, endpoint.route) => endpoint
  }

  vpc_endpoint_id = aws_vpc_endpoint.sca[each.value.endpoint].id
  route_table_id  = aws_route_table.sca[each.value.route].id
}
