resource "aws_security_group" "dsai_mwaa_sg" {
  name   = "${var.prefix}-sg"
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dsai_mwaa_sg.id
}

resource "aws_security_group_rule" "allow_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.dsai_mwaa_sg.id
}

resource "aws_security_group_rule" "self_reference" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.dsai_mwaa_sg.id
}
