resource "aws_efs_file_system" "this" {
  # Configure your EFS file system here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
