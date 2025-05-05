resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  tags = var.tags
}

locals {
  # Create a list of tag expiration rules, one for each tag prefix
  tag_expiration_rules = var.enable_tag_expiration ? [
    for i, tag_prefix in var.tag_prefix_list : {
      rulePriority = i + 1
      description  = "Keep last ${lookup(var.max_image_count_map, tag_prefix, var.default_max_image_count)} images tagged with ${tag_prefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tag_prefix]
        countType     = "imageCountMoreThan"
        countNumber   = lookup(var.max_image_count_map, tag_prefix, var.default_max_image_count)
      }
      action = {
        type = "expire"
      }
    }
  ] : []

  # Create the untagged expiration rule with a priority after all tag rules
  untagged_expiration_rule = var.enable_untagged_expiration ? [
    {
      rulePriority = length(var.tag_prefix_list) + 1
      description  = "Expire untagged images older than ${var.untagged_image_expiration_days} days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = var.untagged_image_expiration_days
      }
      action = {
        type = "expire"
      }
    }
  ] : []
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = concat(local.tag_expiration_rules, local.untagged_expiration_rule)
  })
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.repository_policy != null ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy
}
