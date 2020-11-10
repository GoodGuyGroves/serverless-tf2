resource "aws_cloudwatch_log_group" "tf2-logs" {
  name              = "/ecs/tf2-logs"
  retention_in_days = 14
}