##################
# Security Group #
##################

resource "aws_security_group" "alb_sg" {
  name        = "load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.tag_prefix}-ALB-SG"
  }
}

#################
# Load Balancer #
#################

resource "aws_alb" "alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_id
}

######################
# ALB - Target Group #
######################

resource "aws_alb_target_group" "target_group" {
  name        = var.tg_name
  port        = var.app_port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    timeout             = "3"
    interval            = "30"
    matcher             = "200"
    protocol            = var.protocol // This protocols use the HTTP GET method to send health check requests 
    path                = var.health_check_path
  }
}

################
# ALB- Listner #
################

// Redirect all traffic from the ALB to the target group //
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.http_port
  protocol          = var.protocol

  default_action {
    target_group_arn = aws_alb_target_group.target_group.id
    type             = var.action_type
  }
}

// Note: //

// All the traffic from internet on port 80 will come to the ALB, 
// then listener will listen this traffic on port 80 using the http protocol. 
// Based on the listener rule, it forwards the traffic to the target group. 
// Now target group will route the traffic to port 3000 on which our application is running inside the ecr.