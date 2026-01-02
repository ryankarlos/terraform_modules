resource "aws_mwaa_environment" "dsai_pub" {
  airflow_version       = var.mwaa_version
  dag_s3_path           = var.dags_path
  execution_role_arn    = aws_iam_role.role.arn
  name                  = "${var.prefix}-${var.name}"
  environment_class     = var.env_class
  min_webservers        = 2
  max_webservers        = 2
  min_workers           = 2
  max_workers           = 2
  schedulers            = 2
  webserver_access_mode = var.is_private ? "PRIVATE_ONLY" : "PUBLIC_ONLY"
  requirements_s3_path  = var.has_requirements_file ? aws_s3_object.file_upload_requirements[0].key : null
  kms_key               = var.enable_kms ? module.bucket_key[0].key_arn : null
  network_configuration {
    security_group_ids = [aws_security_group.dsai_mwaa_sg.id]
    subnet_ids         = var.subnet_ids
  }

  source_bucket_arn               = module.dsai_mwaa_bucket.s3_bucket_arn
  weekly_maintenance_window_start = "SUN:19:00" # TODO: Move to var
  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }
  tags = var.tags
}
