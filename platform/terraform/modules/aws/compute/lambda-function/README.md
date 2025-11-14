## Lambda Function Module

This module creates an AWS Lambda function with support for various deployment methods, VPC integration, and comprehensive configuration options.

## Features

- Multiple deployment options (ZIP file, S3, Container image)
- VPC integration for private resource access
- EFS file system mounting
- X-Ray tracing support
- Dead letter queue configuration
- Function URLs with CORS
- Lambda layers support
- Environment variable encryption with KMS
- CloudWatch Logs integration
- Multiple runtime and architecture support
- Ephemeral storage configuration

## Usage

### Basic ZIP-based Lambda

```hcl
module "lambda_function" {
  source = "../../modules/aws/compute/lambda-function"

  function_name = "api-handler"
  description   = "Handles API requests"
  role_arn      = aws_iam_role.lambda.arn

  filename         = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
  handler          = "index.handler"
  runtime          = "python3.11"
  timeout          = 30
  memory_size      = 512

  environment_variables = {
    ENVIRONMENT = "production"
    DB_HOST     = aws_db_instance.main.endpoint
  }

  tags = {
    Environment = "production"
  }
}
```

### Container-based Lambda

```hcl
module "lambda_container" {
  source = "../../modules/aws/compute/lambda-function"

  function_name = "ml-inference"
  role_arn      = aws_iam_role.lambda.arn

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.lambda.repository_url}:latest"
  timeout      = 300
  memory_size  = 3008

  image_config = {
    command = ["/app/handler.handler"]
  }

  tags = {
    Service = "ml"
  }
}
```

### Lambda with VPC and EFS

```hcl
module "lambda_vpc" {
  source = "../../modules/aws/compute/lambda-function"

  function_name = "vpc-task-processor"
  role_arn      = aws_iam_role.lambda.arn

  filename    = "function.zip"
  handler     = "index.handler"
  runtime     = "nodejs18.x"
  timeout     = 60
  memory_size = 1024

  vpc_config = {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  file_system_config = {
    arn              = aws_efs_access_point.lambda.arn
    local_mount_path = "/mnt/data"
  }

  ephemeral_storage_size = 1024

  tracing_mode = "Active"

  tags = {
    Environment = "production"
  }
}
```

### Lambda with Function URL

```hcl
module "lambda_url" {
  source = "../../modules/aws/compute/lambda-function"

  function_name = "public-api"
  role_arn      = aws_iam_role.lambda.arn

  filename    = "function.zip"
  handler     = "index.handler"
  runtime     = "python3.11"

  create_function_url  = true
  function_url_auth_type = "NONE"

  function_url_cors = {
    allow_origins = ["https://example.com"]
    allow_methods = ["GET", "POST"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 3600
  }

  tags = {
    Public = "true"
  }
}
```

## Supported Runtimes

- **Python**: python3.8, python3.9, python3.10, python3.11, python3.12
- **Node.js**: nodejs16.x, nodejs18.x, nodejs20.x
- **Java**: java8.al2, java11, java17, java21
- **Go**: provided.al2, provided.al2023
- **.NET**: dotnet6, dotnet8
- **Ruby**: ruby3.2, ruby3.3

## Architectures

- **x86_64**: Standard x86 architecture
- **arm64**: ARM-based Graviton2 processors (lower cost, better performance)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Name of the Lambda function | `string` | n/a | yes |
| role_arn | IAM role ARN | `string` | n/a | yes |
| runtime | Function runtime | `string` | `null` | no |
| handler | Function handler | `string` | `null` | no |
| memory_size | Memory in MB | `number` | `128` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | ARN of the Lambda function |
| function_name | Name of the function |
| function_url | Function URL endpoint |
| function_invoke_arn | ARN for invoking the function |
