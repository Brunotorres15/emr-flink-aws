resource "aws_security_group" "main_security_group" {
  name = "${var.project}-main-security-group-${var.environment}" 
  description = "Allow inbound traffic for EMR main node "
  vpc_id      = var.vpc_id 

  revoke_rules_on_delete = true

  tags = {
    Name = "allow_tls"
  }

    ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "core_security_group" {
  name = "${var.project}-core-security-group-${var.environment}" 
  description = "Allow inbound and outbond traffic for EMR core nodes"
  vpc_id      = var.vpc_id 

  revoke_rules_on_delete = true

  tags = {
    Name = "allow_tls"
  }

    ingress {
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    self = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
