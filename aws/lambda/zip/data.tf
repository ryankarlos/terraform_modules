data "aws_caller_identity" "current" {}
data "aws_iam_policy" "existing_vpc_eni" {
  count = var.create_custom_vpc_policy ? 0 : 1
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/vpc_ENI"
}
