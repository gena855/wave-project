resource "aws_key_pair" "wave" {
  key_name   = "wave"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

