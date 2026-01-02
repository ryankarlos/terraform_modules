module "dsai_mwaa_bucket" {
  source               = "../s3/"
  bucket_name          = var.bucket_name
  tags                 = var.tags
  force_destroy        = var.force_destroy_bucket
  enable_versioning    = true
  enable_s3_encryption = true
  read_write_role_arn  = aws_iam_role.role.arn
  admin_role_arn       = aws_iam_role.role.arn
  enable_kms           = var.enable_kms
  kms_key              = var.enable_kms ? module.bucket_key[0].key_arn : null
}

resource "aws_s3_object" "file_upload_requirements" {
  count  = var.has_requirements_file ? 1 : 0
  bucket = module.dsai_mwaa_bucket.s3_bucket_id
  key    = "requirements.txt"
  source = var.requirements_file
}

module "dsai_mwaa_data_bucket" {
  source               = "../s3/"
  bucket_name          = "${var.bucket_name}-data"
  tags                 = var.tags
  force_destroy        = var.force_destroy_bucket
  enable_versioning    = false
  enable_s3_encryption = true
  read_write_role_arn  = aws_iam_role.role.arn
  admin_role_arn       = aws_iam_role.role.arn
  enable_kms           = var.enable_kms
  kms_key              = var.enable_kms ? module.bucket_key[0].key_arn : null
}
