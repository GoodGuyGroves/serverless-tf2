resource "aws_ecs_cluster" "rsa_tf" {
  name               = "rsa_tf"
  capacity_providers = ["FARGATE_SPOT"]
  # setting {
  #   name  = "containerInsights"
  #   value = "enabled"
  # }
}

# Create a task definition - Defines a container configuration to be used to launch a container
resource "aws_ecs_task_definition" "tf2_server" {
  family                   = "tf2-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn            = aws_iam_role.ecs_efs_role.arn
  execution_role_arn       = aws_iam_role.ecs_efs_role.arn
  volume {
    name = "tf2-efs"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.tf2_efs.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.tf2_ap.id
        iam             = "ENABLED"
      }
    }
  }
  container_definitions = templatefile(
    "json-defs/tf2-server.json",
    { 
      # srcds_token = aws_ssm_parameter.tf2_srcds_token.value
      srcds_token = "355A206F51D7B1BD6AA365C798B082BF"
    }
  )

  # depends_on = [
  #   aws_ssm_parameter.tf2_srcds_token
  # ]
}

# Create a Service - References a task definition to bring up a container based on a scaling group
# resource "aws_ecs_service" "tf2_service" {
#   name             = "tf2_service"
#   cluster          = aws_ecs_cluster.rsa_tf.id
#   task_definition  = aws_ecs_task_definition.tf2_server.arn
#   desired_count    = 1
#   # Error: InvalidParameterException: Specifying both a launch type and capacity provider strategy is not supported. Remove one and try again. "tf2_service"
#   # launch_type      = "FARGATE"
#   platform_version = "1.4.0"

#   capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     weight            = 100
#     base              = 1
#   }

#   network_configuration {
#     security_groups  = [aws_security_group.tf2_ecs.id]
#     subnets          = [data.aws_subnet.terraform-public-1a.id]
#     assign_public_ip = true
#   }
# }
