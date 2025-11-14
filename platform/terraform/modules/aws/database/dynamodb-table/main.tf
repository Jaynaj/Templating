resource "aws_dynamodb_table" "this" {
  # Configure your DynamoDB table here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
