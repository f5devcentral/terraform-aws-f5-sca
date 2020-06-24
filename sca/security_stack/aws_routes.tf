## routes to point at ENI ids.

#alien range route
resource "aws_route" "internet_alien_range" {
 route_table_id  = var.route_tables.value.internet
 destination_cidr_block = "192.168.100.0/24"
 network_interface_id = module.external_az1.public_nic_ids[0]
}

#outbound routes
resource "aws_route" "dmz_outside_outbound" {
 route_table_id  = var.route_tables.value.to_security_inspection_1
 destination_cidr_block = "0.0.0.0/0"
 network_interface_id = module.external_az1.nics_by_device_index[0][3].eni
}

resource "aws_route" "dmz_internal_outbound" {
 route_table_id  = var.route_tables.value.frm_security_inspection_1
 destination_cidr_block = "0.0.0.0/0"
 network_interface_id = module.ips_az1.nics_by_device_index[0][3].eni
}

resource "aws_route" "internal_outbound" {
 route_table_id  = var.route_tables.value.sec_internal
 destination_cidr_block = "0.0.0.0/0"
 network_interface_id = module.internal_az1.nics_by_device_index[0][3].eni
}

#routes to RFC1918 routes pointing to ENI id's

# dmz_outside subnet rt's
resource "aws_route" "dmz_outside_inboundrt1" {
 route_table_id  = var.route_tables.value.to_security_inspection_1
 destination_cidr_block = "10.0.0.0/8"
 network_interface_id = module.ips_az1.nics_by_device_index[0][1].eni
}

resource "aws_route" "dmz_outside_inboundrt2" {
 route_table_id  = var.route_tables.value.to_security_inspection_1
 destination_cidr_block = "172.16.0.0/12"
 network_interface_id = module.ips_az1.nics_by_device_index[0][1].eni
}

resource "aws_route" "dmz_outside_inboundrt3" {
 route_table_id  = var.route_tables.value.to_security_inspection_1
 destination_cidr_block = "192.168.0.0/16"
 network_interface_id = module.ips_az1.nics_by_device_index[0][1].eni
}

# dmz_inside subnet rt's
resource "aws_route" "dmz_inside_inboundrt1" {
 route_table_id  = var.route_tables.value.frm_security_inspection_1
 destination_cidr_block = "10.0.0.0/8"
 network_interface_id = module.internal_az1.nics_by_device_index[0][1].eni
}

resource "aws_route" "dmz_inside_inboundrt2" {
 route_table_id  = var.route_tables.value.frm_security_inspection_1
 destination_cidr_block = "172.16.0.0/12"
 network_interface_id = module.internal_az1.nics_by_device_index[0][1].eni
}

resource "aws_route" "dmz_inside_inboundrt3" {
 route_table_id  = var.route_tables.value.frm_security_inspection_1
 destination_cidr_block = "192.168.0.0/16"
 network_interface_id = module.internal_az1.nics_by_device_index[0][1].eni
}









