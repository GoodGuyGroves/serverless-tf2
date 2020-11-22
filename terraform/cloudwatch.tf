resource "aws_cloudwatch_log_group" "tf2_logs" {
  name              = "/ecs/tf2-logs"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/aws/events/ecs/serverless-gameservers"
  retention_in_days = 14
}