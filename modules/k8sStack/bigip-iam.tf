resource "aws_iam_role" "bigip-iam-role" {
  name = "${var.prefix}-bigip-iam-role"
  assume_role_policy = file("${path.module}/json/bigip-iam-role.json")
  tags = {
    name = "${var.prefix}-bigip_iam_role"
  }
}

resource "aws_iam_policy" "bigip-iam-policy" {
  name        = "${var.prefix}-bigip-iam-policy"
  description = "for bigip cloud failover extension"
  policy      = file("${path.module}/json/bigip-iam-policy.json")
}

resource "aws_iam_policy_attachment" "bigip-iam-policy-attach" {
  depends_on = [aws_iam_policy.bigip-iam-policy]
  name       = "${var.prefix}-bigip-iam-policy-attach"
  roles      = [aws_iam_role.bigip-iam-role.name]
  policy_arn = aws_iam_policy.bigip-iam-policy.arn
}

resource "aws_iam_instance_profile" "bigip-iam-instance-profile" {
  depends_on = [aws_iam_role.bigip-iam-role]
  name = "${var.prefix}-bigip-iam-instance-profile"
  role = aws_iam_role.bigip-iam-role.name
}
