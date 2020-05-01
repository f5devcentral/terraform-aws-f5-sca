output aws_region {
  value = var.aws_region
}

output project {
  value = var.project
}

output random_id {
  value = random_id.id.hex
}

output vpcs {
  value = {
    for vpc in aws_vpc.sca :
    vpc.id => vpc
  }
}

output subnets {
  value = {
    for subnet in aws_subnet.sca :
    subnet.id => subnet
  }
}

# output secrets_manager_name {
#   value = module.core.secrets_manager_name
# }

# output iam_instance_profile_name {
#   value = aws_iam_instance_profile.bigip_profile.name
# }

# output security_groups {
#   value = {
#     management = module.bigip_mgmt_sg.this_security_group_id
#     public     = module.bigip_sg.this_security_group_id
#     private    = module.bigip_sg.this_security_group_id
#   }
# }

# output vpcs {
#   description = "Secure Cloud Architecture VPCs"
#   value = {
#     security    = module.core.security-vpc
#     application = module.core.application-test
#     container   = module.core.container-test

#   }
# }
# output subnets {
#   value = {
#     az1 = {
#       security = {
#         internet           = module.core.sec_subnet_internet_region-az-1
#         egress_to_ch1      = module.core.sec_subnet_egress_to_ch1_region-az-1
#         ingress_frm_ch1    = module.core.sec_subnet_ingress_frm_ch1_region-az-1
#         application_region = module.core.sec_subnet_application_region-az-1
#         egress_to_ch2      = module.core.sec_subnet_egress_to_ch2_region-az-1
#         ingress_frm_ch2    = module.core.sec_subnet_ingress_frm_ch2_region-az-1
#         dmz_outside        = module.core.sec_subnet_dmz_outside_region-az-1
#         dmz_inside         = module.core.sec_subnet_dmz_inside_region-az-1
#         mgmt               = module.core.sec_subnet_mgmt_region-az-1
#         peering            = module.core.sec_subnet_peering_region-az-1

#       }
#       application = {
#         internet           = module.core.app_subnet_internet_region-az-1
#         dmz_1              = module.core.app_subnet_dmz_1_region-az-1
#         application_region = module.core.app_subnet_application_region-az-1
#         peering            = module.core.app_subnet_peering_region-az-1
#         mgmt               = module.core.app_subnet_mgmt_region-az-1
#       }
#       container = {
#         internet           = module.core.container_subnet_internet_region-az-1
#         dmz_1              = module.core.container_subnet_dmz_1_region-az-1
#         application_region = module.core.container_subnet_application_region-az-1
#         peering            = module.core.container_subnet_peering_region-az-1
#         mgmt               = module.core.container_subnet_mgmt_region-az-1
#       }
#     }
#     az2 = {
#       security = {
#         internet           = module.core.sec_subnet_internet_region-az-2
#         egress_to_ch1      = module.core.sec_subnet_egress_to_ch1_region-az-2
#         ingress_frm_ch1    = module.core.sec_subnet_ingress_frm_ch1_region-az-2
#         application_region = module.core.sec_subnet_application_region-az-2
#         egress_to_ch2      = module.core.sec_subnet_egress_to_ch2_region-az-2
#         ingress_frm_ch2    = module.core.sec_subnet_ingress_frm_ch2_region-az-2
#         dmz_outside        = module.core.sec_subnet_dmz_outside_region-az-2
#         dmz_inside         = module.core.sec_subnet_dmz_inside_region-az-2
#         mgmt               = module.core.sec_subnet_mgmt_region-az-2
#         peering            = module.core.sec_subnet_peering_region-az-2

#       }
#       application = {
#         internet           = module.core.app_subnet_internet_region-az-2
#         dmz_1              = module.core.app_subnet_dmz_1_region-az-2
#         application_region = module.core.app_subnet_application_region-az-2
#         peering            = module.core.app_subnet_peering_region-az-2
#         mgmt               = module.core.app_subnet_mgmt_region-az-2
#       }
#       container = {
#         internet           = module.core.container_subnet_internet_region-az-2
#         dmz_1              = module.core.container_subnet_dmz_1_region-az-2
#         application_region = module.core.container_subnet_application_region-az-2
#         peering            = module.core.container_subnet_peering_region-az-2
#         mgmt               = module.core.container_subnet_mgmt_region-az-2
#       }
#     }
#   }
# }

# output route_tables {
#   value = {
#     internet                  = module.core.internet_rt
#     sec_internal              = module.core.sec_Internal_rt
#     to_security_inspection_1  = module.core.to_security_insepction_1_rt
#     frm_security_inspection_1 = module.core.frm_security_insepction_1_rt
#     to_security_inspection_2  = module.core.to_security_insepction_2_rt
#     frm_security_inspection_2 = module.core.frm_security_insepction_2_rt
#     app_tgw                   = module.core.app_tgw_main_rt
#     container_tgw             = module.core.container_tgw_main_rt
#   }
# }

# output transit_gateways {
#   value = {
#     security_to_app       = module.core.security-app-tgw
#     security-app-tgw-main = module.core.security-app-tgw-main-rt
#   }
# }
