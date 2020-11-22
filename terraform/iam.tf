resource "aws_iam_role" "ecs_efs_role" {
  name               = "TerraformECSandEFSRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_policy" "ecs_efs_policy" {
  name        = "TerraformECSandEFSPolicy"
  description = "Allows ECS access to ECR, EFS and Cloudwatch."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:DescribeMountTargets",
        "ecs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_efs_attach" {
  role       = aws_iam_role.ecs_efs_role.name
  policy_arn = aws_iam_policy.ecs_efs_policy.arn
}

resource "aws_iam_role" "lambda_ecs_role" {
  name               = "LambdaECSRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_ecs_policy" {
  name        = "LambdaECSPolicy"
  description = "Allows Lambda to call ECS."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ecs_attach" {
  role       = aws_iam_role.lambda_ecs_role.name
  policy_arn = aws_iam_policy.lambda_ecs_policy.arn
}