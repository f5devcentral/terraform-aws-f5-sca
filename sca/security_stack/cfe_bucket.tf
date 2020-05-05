resource "aws_s3_bucket" "cfe_external_bucket" {
  #Error: expected length of bucket_prefix to be in the range (0 - 37), got mydeployment-sca-tf--cfe-external-bucket-4bf0
  bucket_prefix = format(
    "%s-cfe-external-bucket-%s",
    var.project.value,
    var.random_id.value
  )
  tags = {
   f5_cloud_failover_label = format( "%s-external-%s", var.project.value, var.random_id.value )
  }
}

