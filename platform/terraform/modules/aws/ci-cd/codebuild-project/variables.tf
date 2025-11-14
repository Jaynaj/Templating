variable "name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "description" {
  description = "Description of the CodeBuild project"
  type        = string
  default     = ""
}

variable "service_role" {
  description = "IAM service role ARN for CodeBuild"
  type        = string
}

variable "artifacts" {
  description = "Artifact configuration"
  type = object({
    type      = string
    location  = optional(string)
    packaging = optional(string)
    name      = optional(string)
  })
  default = {
    type = "NO_ARTIFACTS"
  }
}

variable "environment" {
  description = "Build environment configuration"
  type = object({
    compute_type                = string
    image                       = string
    type                        = string
    image_pull_credentials_type = optional(string)
    privileged_mode             = optional(bool)
    environment_variables = optional(list(object({
      name  = string
      value = string
      type  = optional(string)
    })))
  })
}

variable "source" {
  description = "Source configuration"
  type = object({
    type            = string
    location        = optional(string)
    buildspec       = optional(string)
    git_clone_depth = optional(number)
    git_submodules_config = optional(object({
      fetch_submodules = bool
    }))
  })
}

variable "cache" {
  description = "Cache configuration"
  type = object({
    type     = string
    location = optional(string)
    modes    = optional(list(string))
  })
  default = null
}

variable "logs_config" {
  description = "Logs configuration"
  type = object({
    cloudwatch_logs = optional(object({
      status      = string
      group_name  = optional(string)
      stream_name = optional(string)
    }))
    s3_logs = optional(object({
      status              = string
      location            = optional(string)
      encryption_disabled = optional(bool)
    }))
  })
  default = null
}

variable "vpc_config" {
  description = "VPC configuration for CodeBuild"
  type = object({
    vpc_id             = string
    subnets            = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "build_timeout" {
  description = "Build timeout in minutes"
  type        = number
  default     = 60
}

variable "queued_timeout" {
  description = "Queued timeout in minutes"
  type        = number
  default     = 480
}

variable "concurrent_build_limit" {
  description = "Maximum number of concurrent builds"
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
