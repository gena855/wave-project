resource "aws_instance" "ansible-controler" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.public-subnet-a.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.wave.key_name

  #Attach IAM role
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  depends_on = [aws_nat_gateway.wave-nat-gw]

  tags = {
    Name = "ansible-controler"
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "~/.ssh/private-key"
  }

  provisioner "file" {
    source      = "../ansible"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0400 /home/ubuntu/.ssh/private-key",
      "chmod 0744 /home/ubuntu/ansible/docker-install.sh",
      "sudo apt-get update -y",
      "sudo apt-get install python3 -y",
      "sudo apt-get install python3-pip -y",
      "sudo pip3 install boto3",
      "sudo apt-get install ansible -y",
      "mkdir -p /home/ubuntu/www/html",
      "cd ansible",
      "ansible-playbook nginx.yaml",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "4m"
  }
}

#resource "nul_resource" "connect_webserver1" {

#  provisioner "remote-exec" {
#        script = "../ansible/docker-install.sh"
#  }

#  connection {
#    bastion_host = "${aws_instance.ansible-controler.public_ip}"
#    host         = "${aws_instance.webserver1.private_ip}"
#    user         = "ubuntu"
#    private_key  = "${file("~/.ssh/id_rsa")}"
#  }
#}

resource "aws_instance" "webserver1" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.private-subnet-a.id

  # the security group
  vpc_security_group_ids = [aws_security_group.web-servers.id]

  # the public SSH key
  key_name = "wave"

  tags = {
    Name   = "webserver1"
    server = "webserver"
  }
}

resource "aws_instance" "webserver2" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.private-subnet-b.id

  # the security group
  vpc_security_group_ids = [aws_security_group.web-servers.id]

  # the public SSH key
  key_name = "wave"

  tags = {
    Name   = "webserver2"
    server = "webserver"
  }
}
