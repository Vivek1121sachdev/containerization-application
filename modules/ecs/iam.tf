#######################
# IAM Role Data Block #
#######################

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

############
# IAM Role #
############

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.tag_prefix}-ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}

##########################
# Role-Policy Attachment #
##########################

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}