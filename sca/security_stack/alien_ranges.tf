 resource "aws_route" "internet_alien_range" {
 route_table_id  = var.route_tables.value.internet
 destination_cidr_block = "192.168.100.0/24"
 network_interface_id = module.external_az1.public_nic_ids[0]
 }
