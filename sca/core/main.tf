locals {
  tags = merge(
    var.tags,
    {
      Project : var.project
    }
  )
  postfix = random_id.id.hex
}
#
# Create a random id
#
resource "random_id" "id" {
  byte_length = 2
}
