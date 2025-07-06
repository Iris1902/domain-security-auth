resource "aws_security_group" "sg" {
  name_prefix = "${var.name}-sg"
  vpc_id      = var.vpc_id

   # SSH (solo tú deberías limitar por IP si es producción)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puerto 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puerto 8080 (microservicio)
  ingress {
    from_port   = 8080
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64encode(templatefile("${path.module}/docker-compose.tpl", {
    image      = var.image,
    tag        = var.branch,
    port       = var.port,
    name       = var.name,
    jwt_secret = var.jwt_secret
  }))
}

resource "aws_lb" "alb" {
  name               = "auth-encrypt-domain-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [var.subnet1, var.subnet2]
}


resource "aws_lb_target_group" "tg_encrypt" {
  name     = "aed-encrypt-tg"
  port     = var.port_encrypt
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/encrypt/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_jwt" {
  name     = "aed-jwt-tg"
  port     = var.port_jwt
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/jwt/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_jwt_validate" {
  name     = "aed-jwtval-tg"
  port     = var.port_jwt_validate
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/jwt-validate/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_encrypt.arn
  }
}

resource "aws_lb_listener_rule" "rule_encrypt" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_encrypt.arn
  }
  condition {
    path_pattern {
      values = ["/encrypt*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_jwt" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 101
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_jwt.arn
  }
  condition {
    path_pattern {
      values = ["/jwt*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_jwt_validate" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 102
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_jwt_validate.arn
  }
  condition {
    path_pattern {
      values = ["/jwt-validate*"]
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 2
  vpc_zone_identifier  = [var.subnet1, var.subnet2]
  target_group_arns    = [
    aws_lb_target_group.tg_encrypt.arn,
    aws_lb_target_group.tg_jwt.arn,
    aws_lb_target_group.tg_jwt_validate.arn
  ]
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}
