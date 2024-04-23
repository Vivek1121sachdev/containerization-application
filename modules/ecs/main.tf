##################
# Security Group #
##################

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_sg" {
    name        = "${var.tag_prefix}-ecs-tasks-security-group"
    description = "allow inbound access from the ALB only"
    vpc_id      = var.vpc_id

    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        security_groups = var.lb_sg
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

###############
# ECS Cluster #
###############

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_prefix}-${var.cluster_name}"
}

#######################
# ECS Task Defination #
#######################

resource "aws_ecs_task_definition" "task_defination" {
    family                   = "${var.tag_prefix}-app-task"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
    container_definitions    = <<EOF
  [
    {
      "name": "${var.tag_prefix}-app",
      "image": "${var.ecr_image}",
      "essential": true,
      "portMappings": [
        {
          "hostPort": ${var.app_port},
          "protocol": "tcp",
          "containerPort": ${var.app_port}
        }
      ],
      "environment": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.tag_prefix}"
        }
      }
    }
  ]

  EOF
}


###############
# ECS Service #
###############

resource "aws_ecs_service" "main" {
    name            = "${var.tag_prefix}-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.task_defination.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs_sg.id]
        subnets          = var.private_subnet
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.tg_arn
        container_name   = "${var.tag_prefix}-app"
        container_port   = var.app_port
    }

    depends_on = [aws_iam_role_policy_attachment.role_policy_attachment]
}