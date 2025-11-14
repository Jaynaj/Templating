resource "aws_codepipeline" "this" {
  # Configure your CodePipeline for ECS here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
