module "bucket_key" {
  count               = var.enable_kms ? 1 : 0
  source              = "../kms/"
  deletion_window     = 10
  account_id          = var.account_id
  key_name            = "${var.bucket_name}-key"
  enable_key_rotation = true
}
