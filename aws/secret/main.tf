resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description             = "Secret created by Terraform"
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = module.secret_kms.key_id
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_type == "plaintext" ? file(var.secret_file_path): var.secret_value
}

module "secret_kms" {
  source              = "../kms/"
  deletion_window     = var.key_deletion_window
  key_name            = "${var.secret_name}-key"
  enable_key_rotation = true
  account_id          = var.account_id
}
