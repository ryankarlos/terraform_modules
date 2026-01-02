resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  tags          = var.tags
  force_destroy = var.force_destroy
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.admin_role_arn]
    }
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cidr_range
    }
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.read_write_role_arn]
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cidr_range
    }
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.read_only_role_arn]
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cidr_range
    }
  }
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:DeleteBucket"]
    resources = [aws_s3_bucket.this.arn]
    condition {
      test     = "StringNotLike"
      variable = "aws:UserId"
      values   = [var.delete_role_arn]
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  count  = var.enable_kms ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.enable_kms ? var.kms_key : null
      sse_algorithm     = var.enable_kms ? "aws:kms" : var.s3_encryption
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  count  = var.enable_expiration ? 1 : 0
  rule {
    id = "expire-objects"
    filter {
      prefix = var.expire_prefix
    }
    expiration {
      days = var.expiration_days # Number of days after object creation for it to be expired
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id
  count  = var.enable_bucketnotifications ? 1 : 0
  dynamic "lambda_function" {
    for_each = [for n in var.event_notifications : n if n.type == "lambda"]
    content {
      lambda_function_arn = lambda_function.value.arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "queue" {
    for_each = [for n in var.event_notifications : n if n.type == "sqs"]
    content {
      queue_arn    = queue.value.arn
      events       = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }

  dynamic "topic" {
    for_each = [for n in var.event_notifications : n if n.type == "sns"]
    content {
      topic_arn    = topic.value.arn
      events       = topic.value.events
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
    }
  }
}
