#datasync source location 
resource "aws_datasync_location_s3" "s3_source" {
  s3_bucket_arn = var.source_bucket_arn
  subdirectory  = var.s3_source_object_prefix

  s3_config {
    bucket_access_role_arn = var.datasync_role_arn
  }
  tags = var.tags
}

#datasync target location
resource "aws_datasync_location_s3" "s3_dest" {
  s3_bucket_arn = var.destination_s3_bucket_arn
  subdirectory  = var.s3_dest_object_prefix

  s3_config {
    bucket_access_role_arn = var.datasync_role_arn
  }
  tags = var.tags
}


resource "aws_datasync_task" "s3tos3" {
  name                    = var.datasync_task_name
  source_location_arn      = aws_datasync_location_s3.s3_source.arn
  destination_location_arn = aws_datasync_location_s3.s3_dest.arn

  options {
    verify_mode    = "ONLY_FILES_TRANSFERRED"
    overwrite_mode = "ALWAYS"
    posix_permissions = "NONE"
    gid               = "NONE"
    uid               = "NONE"
    preserve_deleted_files = "PRESERVE"
  }
  tags = var.tags
}

