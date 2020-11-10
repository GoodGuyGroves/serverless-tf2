resource "aws_security_group" "tf2_ecs" {
  name        = "tf2-security-group"
  description = "Allows access to TF2"
  vpc_id      = var.vpc_id

  # ingress {
  #   protocol        = "tcp"
  #   from_port       = 2049
  #   to_port         = 2049
  #   security_groups = [aws_security_group.tf2_efs.id]
  # }

  # egress {
  #   protocol        = "tcp"
  #   from_port       = 2049
  #   to_port         = 2049
  #   security_groups = [aws_security_group.tf2_efs.id]
  # }
}

# 1 = ICMP
# 17 = UDP
# 6 = TCP

resource "aws_security_group_rule" "tf2_icmp" {
  protocol          = "icmp"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "http_outbound" {
  protocol          = "6"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "https_outbound" {
  protocol          = "6"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "tf2-efs-inbound" {
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.tf2_efs.id
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "tf2-efs-outbound" {
  protocol          = "tcp"
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.tf2_efs.id
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "steam_game_client_traffic" {
  protocol          = "udp"
  type              = "ingress"
  from_port         = 27015
  to_port           = 27015
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "steam_sourcetv" {
  protocol          = "udp"
  type              = "ingress"
  from_port         = 27020
  to_port           = 27020
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group_rule" "steam_srcds_rcon" {
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 27015
  to_port           = 27015
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf2_ecs.id
}

resource "aws_security_group" "tf2_efs" {
  name        = "tf2-efs-sg"
  description = "Allows TF2 access to EFS"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "tf2-ecs-inbound" {
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.tf2_ecs.id
  security_group_id = aws_security_group.tf2_efs.id
}

resource "aws_security_group_rule" "tf2-ecs-outbound" {
  protocol          = "tcp"
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.tf2_ecs.id
  security_group_id = aws_security_group.tf2_efs.id
}