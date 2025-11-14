variable "name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for CodePipeline"
  type        = string
}

variable "artifact_store" {
  description = "Artifact store configuration"
  type = object({
    location = string
    type     = string
    encryption_key = optional(object({
      id   = string
      type = string
    }))
  })
}

variable "source_stage" {
  description = "Source stage configuration"
  type = object({
    name     = string
    category = string
    owner    = string
    provider = string
    version  = string
    configuration = map(string)
    output_artifacts = list(string)
  })
}

variable "build_stage" {
  description = "Build stage configuration"
  type = object({
    name     = string
    category = string
    owner    = string
    provider = string
    version  = string
    configuration = map(string)
    input_artifacts  = list(string)
    output_artifacts = list(string)
  })
  default = null
}

variable "deploy_stage" {
  description = "Deploy stage configuration"
  type = object({
    name     = string
    category = string
    owner    = string
    provider = string
    version  = string
    configuration = map(string)
    input_artifacts = list(string)
  })
}

variable "additional_stages" {
  description = "Additional pipeline stages"
  type = list(object({
    name = string
    actions = list(object({
      name             = string
      category         = string
      owner            = string
      provider         = string
      version          = string
      configuration    = map(string)
      input_artifacts  = optional(list(string))
      output_artifacts = optional(list(string))
      run_order        = optional(number)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
