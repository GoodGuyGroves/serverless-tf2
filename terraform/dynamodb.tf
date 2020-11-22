resource "aws_dynamodb_table" "games_defruss" {
  name           = "games-defruss"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

#   tags = {
#     ""        = ""
#   }
}