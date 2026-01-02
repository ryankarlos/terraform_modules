# SageMaker Domain
resource "aws_sagemaker_domain" "domain" {
  domain_name             = var.domain_name
  auth_mode               = var.auth_mode
  vpc_id                  = var.vpc_id
  subnet_ids              = var.workload_subnet_ids
  app_network_access_type = "VpcOnly"

  default_user_settings {
    execution_role = aws_iam_role.admin.arn

    security_groups = var.workload_security_group_ids
    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = var.storage_size.default
        maximum_ebs_volume_size_in_gb = var.storage_size.max
      }
    }

    code_editor_app_settings {
      #lifecycle_config_arns = var.lifecycle_configuration_arn != "" ? [var.lifecycle_configuration_arn] : []
      app_lifecycle_management {
        idle_settings {
          lifecycle_management        = "ENABLED"
          min_idle_timeout_in_minutes = var.idle_shutdown
          max_idle_timeout_in_minutes = var.idle_shutdown + 15
          idle_timeout_in_minutes     = var.idle_shutdown
        }
      }
    }

    jupyter_lab_app_settings {
      #lifecycle_config_arns = var.lifecycle_configuration_arn != "" ? [var.lifecycle_configuration_arn] : []
      app_lifecycle_management {
        idle_settings {
          lifecycle_management        = "ENABLED"
          min_idle_timeout_in_minutes = var.idle_shutdown
          max_idle_timeout_in_minutes = var.idle_shutdown + 15
          idle_timeout_in_minutes     = var.idle_shutdown
        }
      }
    }

    studio_web_portal_settings {
      hidden_instance_types = var.hidden_instance_types
    }
  }

  domain_settings {
    docker_settings {
      enable_docker_access = "ENABLED"
    }
  }

  default_space_settings {
    execution_role = aws_iam_role.admin.arn
    jupyter_lab_app_settings {
      #lifecycle_config_arns = var.lifecycle_configuration_arn != "" ? [var.lifecycle_configuration_arn] : []
      app_lifecycle_management {
        idle_settings {
          lifecycle_management        = "ENABLED"
          min_idle_timeout_in_minutes = var.idle_shutdown
          max_idle_timeout_in_minutes = var.idle_shutdown + 15
          idle_timeout_in_minutes     = var.idle_shutdown
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      default_user_settings[0].code_editor_app_settings[0].lifecycle_config_arns,
      default_user_settings[0].jupyter_lab_app_settings[0].lifecycle_config_arns,
      default_user_settings[0].jupyter_server_app_settings,
      default_user_settings[0].kernel_gateway_app_settings,
      default_space_settings[0].jupyter_lab_app_settings[0].lifecycle_config_arns
    ]
  }
}



resource "aws_vpc_endpoint" "sagemaker_endpoints" {
  for_each = tomap({
    api      = "com.amazonaws.${data.aws_region.current.name}.sagemaker.api",
    runtime  = "com.amazonaws.${data.aws_region.current.name}.sagemaker.runtime"
    mlflow   = "aws.sagemaker.${data.aws_region.current.name}.experiments"
    notebook = "aws.sagemaker.${data.aws_region.current.name}.notebook"
  })

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  private_dns_enabled = true

  security_group_ids = var.endpoint_security_group_ids

  tags = {
    Name = "vpce-sagemaker-${each.key}"
  }
}


# this resource gets set if auth mode is IAM
resource "aws_sagemaker_user_profile" "iam_users" {
  for_each          = toset(var.users_iam)
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = each.key
}


# this resource gets set if auth mode is SSO
resource "aws_sagemaker_user_profile" "profile" {
  for_each                       = tomap(var.users_sso)
  domain_id                      = aws_sagemaker_domain.domain.id
  user_profile_name              = each.key # needs to satisfy pattern  ^[a-zA-Z0-9](-*[a-zA-Z0-9]){0,62} 
  single_sign_on_user_identifier = "UserName"
  single_sign_on_user_value      = each.value
}

# need to do below as suggesed in last comment in https://github.com/aws/aws-cdk/issues/23627#issuecomment-1454163879
# need sso admin application assignment or get access denied when trying to access studio with user profiles


# for sso need this resource block.
resource "aws_ssoadmin_application_assignment" "ssoadmin_application_assignment" {
  for_each        = tomap(var.users_sso)
  application_arn = aws_sagemaker_domain.domain.single_sign_on_application_arn
  principal_id    = data.aws_identitystore_user.identity_users[each.key].user_id
  principal_type  = "USER"
}
