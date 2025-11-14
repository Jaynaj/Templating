resource "aws_codedeploy_deployment_group" "this" {
  # Configure your CodeDeploy for ECS here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
