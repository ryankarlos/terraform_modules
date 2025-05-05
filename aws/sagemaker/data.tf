data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_region" "current" {}


data "aws_ssoadmin_instances" "admin_instances" {}

data "aws_identitystore_user" "identity_users" {
  for_each          = tomap(var.users_sso)
  identity_store_id = tolist(data.aws_ssoadmin_instances.admin_instances.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
}