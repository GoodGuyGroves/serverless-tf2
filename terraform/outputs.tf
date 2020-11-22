# DynamoDB
output "dynamodb_table_games" {
  description = "ARN of the DynamoDB table"
  value = {
      arn = aws_dynamodb_table.games_defruss.arn,
      id = aws_dynamodb_table.games_defruss.id
      }
}
