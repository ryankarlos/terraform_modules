data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {}


data "aws_network_interface" "datasync_interface" {
  id = tolist(aws_vpc_endpoint.datasync_endpoint.network_interface_ids)[0]
}