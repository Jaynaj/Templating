resource "aws_codepipeline" "this" {
  name     = var.name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store.location
    type     = var.artifact_store.type

    dynamic "encryption_key" {
      for_each = lookup(var.artifact_store, "encryption_key", null) != null ? [var.artifact_store.encryption_key] : []
      content {
        id   = encryption_key.value.id
        type = encryption_key.value.type
      }
    }
  }

  # Source Stage
  stage {
    name = var.source_stage.name

    action {
      name             = var.source_stage.name
      category         = var.source_stage.category
      owner            = var.source_stage.owner
      provider         = var.source_stage.provider
      version          = var.source_stage.version
      output_artifacts = var.source_stage.output_artifacts
      configuration    = var.source_stage.configuration
    }
  }

  # Build Stage (optional)
  dynamic "stage" {
    for_each = var.build_stage != null ? [var.build_stage] : []
    content {
      name = stage.value.name

      action {
        name             = stage.value.name
        category         = stage.value.category
        owner            = stage.value.owner
        provider         = stage.value.provider
        version          = stage.value.version
        input_artifacts  = stage.value.input_artifacts
        output_artifacts = stage.value.output_artifacts
        configuration    = stage.value.configuration
      }
    }
  }

  # Deploy Stage
  stage {
    name = var.deploy_stage.name

    action {
      name            = var.deploy_stage.name
      category        = var.deploy_stage.category
      owner           = var.deploy_stage.owner
      provider        = var.deploy_stage.provider
      version         = var.deploy_stage.version
      input_artifacts = var.deploy_stage.input_artifacts
      configuration   = var.deploy_stage.configuration
    }
  }

  # Additional Stages
  dynamic "stage" {
    for_each = var.additional_stages
    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.actions
        content {
          name             = action.value.name
          category         = action.value.category
          owner            = action.value.owner
          provider         = action.value.provider
          version          = action.value.version
          input_artifacts  = lookup(action.value, "input_artifacts", null)
          output_artifacts = lookup(action.value, "output_artifacts", null)
          configuration    = action.value.configuration
          run_order        = lookup(action.value, "run_order", null)
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
