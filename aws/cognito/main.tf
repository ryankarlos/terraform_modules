resource "aws_cognito_user_pool" "user_pool" {
  name = var.cognito_user_pool_name

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "group"
    required                 = false

    string_attribute_constraints {}
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "department"
    required                 = false

    string_attribute_constraints {}
  }

    schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "jobtitle"
    required                 = false

    string_attribute_constraints {}
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_cognito_identity_provider" "saml_provider" {
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = var.cognito_app_client_name
  provider_type = "SAML"


  provider_details = {
    MetadataURL = var.saml_metadata_url
    IDPSignout  = false
  }

  attribute_mapping = var.cognito_saml_attribute_mapping
    
  lifecycle {
    prevent_destroy = true
  }

}


resource "aws_cognito_user_pool_client" "client" {
  name                                 = var.cognito_app_client_name
  generate_secret                      = true
  callback_urls                        = var.callback_urls
  allowed_oauth_flows_user_pool_client = true
  logout_urls                          = var.logout_urls
  allowed_oauth_flows                  = var.allowed_oauth_flows
  access_token_validity = var.access_token_validity
  id_token_validity = var.id_token_validity
  refresh_token_validity = var.refresh_token_validity
  supported_identity_providers         = [var.enable_entraid_auth == true ? var.cognito_app_client_name : "COGNITO"]
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  token_validity_units {
    access_token  =   var.token_validity_units.access_token
    id_token      =   var.token_validity_units.id_token
    refresh_token =  var.token_validity_units.refresh_token
  }
  
  depends_on                           = [aws_cognito_identity_provider.saml_provider]
  
  lifecycle {
    prevent_destroy = true
  }

}


resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = replace(lower(aws_cognito_user_pool.user_pool.id), "_", "")
  user_pool_id = aws_cognito_user_pool.user_pool.id

  lifecycle {
    prevent_destroy = true
  }

}
