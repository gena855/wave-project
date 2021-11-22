#In this template we are creating aws application laadbalancer
#and target group and alb http/https listeners

resource "aws_lb" "web" {
  idle_timeout    = "30"
  name            = "wave-alb"
  security_groups = [aws_security_group.wave-alb-sg.id]
  subnets         = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]
  depends_on      = [aws_instance.ansible-controler]

  tags = {
    Name = "wave-alb"
  }
}

# Target group for the web servers
resource "aws_lb_target_group" "web-tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.wave-vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}
#*******************************
output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}
