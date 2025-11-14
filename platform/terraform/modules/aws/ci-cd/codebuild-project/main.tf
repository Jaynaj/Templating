resource "aws_codebuild_project" "this" {
  # Configure your CodeBuild project here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
