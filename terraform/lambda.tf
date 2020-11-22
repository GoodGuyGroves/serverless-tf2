resource "aws_lambda_permission" "cloudwatch_invoke_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "serverless-gameservers-dev-ECSEventHandler"
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.ecs_game_server.arn
}