
#######################################
# SG for EC2
#######################################

resource "aws_security_group" "ec2" {
  #name        = "${var.tags["SourceMarket"]}-${var.tags["Environment"]}-sg-${var.tags["Application"]}-lambda"
  name        = "ec2-sg"
  description = "SG for EC2"
  vpc_id      = var.vpc_id

}

resource "aws_security_group" "postgresql" {
  name        = "postgresql-sg"
  description = "SG for RDS"
  vpc_id      = var.vpc_id
}

#######################################
# SG Rules EC2
#######################################

resource "aws_security_group_rule" "inbound-ec2-1" {
  type        = "ingress"
  description = "SSH"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.private_ip]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "inbound-ec2-2" {
  type        = "ingress"
  description = "MySQL"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = [var.private_ip]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "outbound-ec2-1" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}


#######################################
# SG Rules RDS
#######################################
resource "aws_security_group_rule" "inbound-postgresql-1" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  cidr_blocks              = [var.private_ip]
#  source_security_group_id = aws_security_group.lambda.id

  security_group_id = aws_security_group.postgresql.id
}

resource "aws_security_group_rule" "outbound-postgresql-1" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
 # source_security_group_id = aws_security_group.lambda.id
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.postgresql.id
}

