resource "aws_instance" "jenkins" {
  ami                    = "ami-03a2c69daedb78c95"
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = var.subnet_id

  tags = {
    Name = "jenkins-master"
  }
}
