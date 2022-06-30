resource "aws_instance" "ec2-prod" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  availability_zone = "us-east-2b"
  key_name = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [aws_security_group.prov_fw.id]

  connection {
    type = "ssh"
    host = aws_instance.ec2-prod.public_ip
    private_key = file("~/testec2.pem")
    user = "ec2-user"
  }

}

resource "aws_key_pair" "ssh" {
  key_name = "provkey"
  public_key = file("~/testec2.pub")
}


resource "aws_security_group" "prov_fw" {
  name = "prov_fw"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
resource "null_resource" "prov_null" {
  triggers = {
    public_ip = aws_instance.ec2-prod.public_ip
  }

  connection {
    type = "ssh"
    host = aws_instance.ec2-prod.public_ip
    ##private_key = file("~/testec2.pem")
    user = "ec2-user"
  }


}
*/
