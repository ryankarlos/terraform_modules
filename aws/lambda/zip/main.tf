data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_lambda_function" "this" {
  function_name = var.function_name
  memory_size = var.lambda_memory

  vpc_config {
    security_group_ids = [
      var.security_group_id
    ]
    subnet_ids = var.subnet_ids
  }

  filename = var.filename
  timeout = var.lambda_timeout
  runtime = "python3.11"
  handler = "lambda_function.lambda_handler"
  source_code_hash = var.source_code_hash
  role = aws_iam_role.lambda_role.arn
  # Conditional layers using ternary operator
  layers = var.enable_layers ? var.lambda_layers : []
  ephemeral_storage {
    size = var.storage
  }
  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }
}



