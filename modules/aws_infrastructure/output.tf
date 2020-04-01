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
#  Ouput VPCs
#
################################################################################################################################################################################################################################################################

output "security-vpc" { value = aws_vpc.security-vpc.id }
output "application-test" { value = aws_vpc.application-test.id }
output "container-test" { value = aws_vpc.container-test.id }

################################################################################################################################################################################################################################################################
#
#  Ouput Subnets
#
################################################################################################################################################################################################################################################################

output "sec_subnet_internet_region-az-1" { value = aws_subnet.sec_subnet_internet_region-az-1.id }
output "sec_subnet_egress_to_ch1_region-az-1" { value = aws_subnet.sec_subnet_egress_to_ch1_region-az-1.id }
output "sec_subnet_ingress_frm_ch1_region-az-1" { value = aws_subnet.sec_subnet_ingress_frm_ch1_region-az-1.id }
output "sec_subnet_application_region-az-1" { value = aws_subnet.sec_subnet_application_region-az-1.id }
output "sec_subnet_egress_to_ch2_region-az-1" { value = aws_subnet.sec_subnet_egress_to_ch2_region-az-1.id }
output "sec_subnet_ingress_frm_ch2_region-az-1" { value = aws_subnet.sec_subnet_ingress_frm_ch2_region-az-1.id }
output "sec_subnet_sec_services_ingress_ch1_region-az-1" { value = aws_subnet.sec_subnet_sec_services_ingress_ch1_region-az-1.id }
output "sec_subnet_sec_services_egress_ch1_region-az-1" { value = aws_subnet.sec_subnet_sec_services_egress_ch1_region-az-1.id }
output "sec_subnet_sec_services_ingress_ch2_region-az-1" { value = aws_subnet.sec_subnet_sec_services_ingress_ch2_region-az-1.id }
output "sec_subnet_sec_services_egress_ch2_region-az-1" { value = aws_subnet.sec_subnet_sec_services_egress_ch2_region-az-1.id }
output "sec_subnet_mgmt_region-az-1" { value = aws_subnet.sec_subnet_mgmt_region-az-1.id }
output "sec_subnet_peering_region-az-1" { value = aws_subnet.sec_subnet_peering_region-az-1.id }
output "sec_subnet_internet_region-az-2" { value = aws_subnet.sec_subnet_internet_region-az-2.id }
output "sec_subnet_egress_to_ch1_region-az-2" { value = aws_subnet.sec_subnet_egress_to_ch1_region-az-2.id }
output "sec_subnet_ingress_frm_ch1_region-az-2" { value = aws_subnet.sec_subnet_ingress_frm_ch1_region-az-2.id }
output "sec_subnet_egress_to_ch2_region-az-2" { value = aws_subnet.sec_subnet_egress_to_ch2_region-az-2.id }
output "sec_subnet_ingress_frm_ch2_region-az-2" { value = aws_subnet.sec_subnet_ingress_frm_ch2_region-az-2.id }
output "sec_subnet_sec_services_ingress_ch1_region-az-2" { value = aws_subnet.sec_subnet_sec_services_ingress_ch1_region-az-2.id }
output "sec_subnet_sec_services_egress_ch1_region-az-2" { value = aws_subnet.sec_subnet_sec_services_egress_ch1_region-az-2.id }
output "sec_subnet_sec_services_ingress_ch2_region-az-2" { value = aws_subnet.sec_subnet_sec_services_ingress_ch2_region-az-2.id }
output "sec_subnet_sec_services_egress_ch2_region-az-2" { value = aws_subnet.sec_subnet_sec_services_egress_ch2_region-az-2.id }
output "sec_subnet_application_region-az-2" { value = aws_subnet.sec_subnet_application_region-az-2.id }
output "sec_subnet_mgmt_region-az-2" { value = aws_subnet.sec_subnet_mgmt_region-az-2.id }
output "sec_subnet_peering_region-az-2" { value = aws_subnet.sec_subnet_peering_region-az-2.id }
output "app_subnet_internet_region-az-1" { value = aws_subnet.app_subnet_internet_region-az-1.id }
output "app_subnet_dmz_1_region-az-1" { value = aws_subnet.app_subnet_dmz_1_region-az-1.id }
output "app_subnet_application_region-az-1" { value = aws_subnet.app_subnet_application_region-az-1.id }
output "app_subnet_peering_region-az-1" { value = aws_subnet.app_subnet_peering_region-az-1.id }
output "app_subnet_mgmt_region-az-1" { value = aws_subnet.app_subnet_mgmt_region-az-1.id }
output "app_subnet_internet_region-az-2" { value = aws_subnet.app_subnet_internet_region-az-2.id }
output "app_subnet_dmz_1_region-az-2" { value = aws_subnet.app_subnet_dmz_1_region-az-2.id }
output "app_subnet_application_region-az-2" { value = aws_subnet.app_subnet_application_region-az-2.id }
output "app_subnet_peering_region-az-2" { value = aws_subnet.app_subnet_peering_region-az-2.id }
output "app_subnet_mgmt_region-az-2" { value = aws_subnet.app_subnet_mgmt_region-az-2.id }
output "container_subnet_internet_region-az-1" { value = aws_subnet.container_subnet_internet_region-az-1.id }
output "container_subnet_dmz_1_region-az-1" { value = aws_subnet.container_subnet_dmz_1_region-az-1.id }
output "container_subnet_application_region-az-1" { value = aws_subnet.container_subnet_application_region-az-1.id }
output "container_subnet_peering_region-az-1" { value = aws_subnet.container_subnet_peering_region-az-1.id }
output "container_subnet_mgmt_region-az-1" { value = aws_subnet.container_subnet_mgmt_region-az-1.id }
output "container_subnet_internet_region-az-2" { value = aws_subnet.container_subnet_internet_region-az-2.id }
output "container_subnet_dmz_1_region-az-2" { value = aws_subnet.container_subnet_dmz_1_region-az-2.id }
output "container_subnet_application_region-az-2" { value = aws_subnet.container_subnet_application_region-az-2.id }
output "container_subnet_peering_region-az-2" { value = aws_subnet.container_subnet_peering_region-az-2.id }
output "container_subnet_mgmt_region-az-2" { value = aws_subnet.container_subnet_mgmt_region-az-2.id }

################################################################################################################################################################################################################################################################
#
#   Output Route Tables
#
################################################################################################################################################################################################################################################################

output "internet_rt" { value = aws_route_table.internet_rt.id }
output "sec_Internal_rt" { value = aws_route_table.sec_Internal_rt.id }
output "to_security_insepction_1_rt" { value = aws_route_table.to_security_insepction_1_rt.id }
output "frm_security_insepction_1_rt" { value = aws_route_table.frm_security_insepction_1_rt.id }
output "to_security_insepction_2_rt" { value = aws_route_table.to_security_insepction_2_rt.id }
output "frm_security_insepction_2_rt" { value = aws_route_table.frm_security_insepction_2_rt.id }
output "app_tgw_main_rt" { value = aws_route_table.app_tgw_main_rt.id }
output "container_tgw_main_rt" { value = aws_route_table.container_tgw_main_rt.id }

################################################################################################################################################################################################################################################################
#
#   Output TGW and TGW Route Tables
#
################################################################################################################################################################################################################################################################


output "security-app-tgw" { value = aws_ec2_transit_gateway.security-app-tgw.id }
output "security-app-tgw-main-rt" { value = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id }
