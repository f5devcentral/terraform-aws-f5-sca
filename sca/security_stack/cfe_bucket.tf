resource "aws_s3_bucket" "cfe_external_bucket" {
  bucket_prefix = format(
    "%s-cfe-external-bucket-%s",
    var.project.value,
    var.random_id.value
  )
  tags = {
   f5_cloud_failover_label = format( "%s-external-%s", var.project.value, var.random_id.value )
  }
}

