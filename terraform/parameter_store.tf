resource "aws_ssm_parameter" "dynamodb_arn_games" {
  name  = "/database/ecs/games/arn"
  type  = "String"
  value = aws_dynamodb_table.games_defruss.arn
}

# resource "aws_ssm_parameter" "tf2_srcds_token" {
#   name = "/ecs/games/tf2/srcds-token/"
#   type = "String"
#   value = "355A206F51D7B1BD6AA365C798B082BF"
# }

resource "aws_ssm_parameter" "ecs_games_cluster" {
  name  = "/ecs/games/cluster/arn"
  type  = "String"
  value = aws_ecs_cluster.rsa_tf.arn
}

data "aws_ssm_parameter" "ecs_event_handler" {
  name = "/projects/serverless-gameservers/lambda/ECSEventHandler/arn"
}

data "aws_ssm_parameter" "ecs_create_server" {
  name = "/projects/serverless-gameservers/lambda/ECSCreateServer/arn"
}