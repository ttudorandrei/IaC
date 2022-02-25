resource "aws_launch_configuration" "tudor" {
  name_prefix     = "tf-asg-tudor-lc-"
  image_id        = "ami-013a6cfe65c679183"
  instance_type   = "t2.micro"
  security_groups = ["sg-0ea75fee7a5d01a78"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tudor" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.tudor.name
  vpc_zone_identifier  = ["subnet-0e4f2d6ef561a1d7e"]
}

resource "aws_lb" "tudor" {
  name               = "tudor-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0ea75fee7a5d01a78"]
  subnets            = ["subnet-0e4f2d6ef561a1d7e", "subnet-07287ddf381145570"]
}

resource "aws_lb_listener" "tudor" {
  load_balancer_arn = aws_lb.tudor.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tudor.arn
  }
}

resource "aws_lb_target_group" "tudor" {
  name     = "tudor-tf-asg-practice"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0863ae82df2ea687b"
}

resource "aws_autoscaling_attachment" "tudor" {
  autoscaling_group_name = aws_autoscaling_group.tudor.id
  alb_target_group_arn   = aws_lb_target_group.tudor.arn
}
