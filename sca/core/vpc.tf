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
