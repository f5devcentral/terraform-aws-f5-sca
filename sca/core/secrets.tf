resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

#
# Create Secret Store and Store BIG-IP Password
#
resource "aws_secretsmanager_secret" "bigip" {
  name = format("%s-bigip-secret-%s", var.project, local.postfix)

  tags = merge(
    local.tags,
    {}
  )
}


resource "aws_secretsmanager_secret_version" "bigip-pwd" {
  secret_id     = aws_secretsmanager_secret.bigip.id
  secret_string = random_password.password.result
}
