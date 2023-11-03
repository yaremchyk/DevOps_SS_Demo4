resource "aws_security_group" "bastion_host" {
  name        = "${var.namespace}-security-group-bastion-host-${var.environment}"
  description = "Bastion host Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}-bastion-host-instance-security-group-${var.environment}"
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.namespace}-ec2-instance-security-group-${var.environment}"
  description = "Security group for EC2 instances in ECS cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Allow SSH ingress traffic from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}-ec2-instance-security-group-${var.environment}"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.namespace}-alb-instance-security-group-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ingress traffic on 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ingress traffic on 443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}-alb-instance-security-group-${var.environment}"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.namespace}-db-security-group-${var.environment}"
  description = "Security group for Db"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ingress traffic on 3306 port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id, aws_security_group.bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}-db-instance-security-group-${var.environment}"
  }
}