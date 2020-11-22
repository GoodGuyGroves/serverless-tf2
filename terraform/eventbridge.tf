# resource "aws_cloudwatch_event_bus" "serverless_gameservers" {
#   name = "serverless_gameservers"
# }

resource "aws_cloudwatch_event_rule" "ecs_game_server" {
  name        = "ecs-game-server"
  description = "Captures changes in ECS containers state"
  # event_bus_name = aws_cloudwatch_event_bus.serverless_gameservers.id
  # role_arn = "value"

  event_pattern = templatefile(
    "json-defs/ecs-event-pattern.json",
    { 
      ecs_cluster_arn = aws_ssm_parameter.ecs_games_cluster.value
    }
  )
}

resource "aws_cloudwatch_event_target" "lambda_ecs_event_handler" {
  arn  = data.aws_ssm_parameter.ecs_event_handler.value
  rule = aws_cloudwatch_event_rule.ecs_game_server.name
  # event_bus_name = aws_cloudwatch_event_bus.serverless_gameservers.id
}

resource "aws_cloudwatch_event_target" "loggroup_ecs_event_handler" {
  arn  = aws_cloudwatch_log_group.ecs_logs.arn
  rule = aws_cloudwatch_event_rule.ecs_game_server.name
  # event_bus_name = aws_cloudwatch_event_bus.serverless_gameservers.id
}
