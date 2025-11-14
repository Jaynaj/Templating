resource "aws_fsx_lustre_file_system" "this" {
  # Configure your FSx file system here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
