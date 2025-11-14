# Launch Template Module

This module creates an AWS EC2 Launch Template with comprehensive configuration options for use with Auto Scaling Groups, EC2 Fleet, or Spot Fleet.

## Features

- Comprehensive instance configuration
- Block device mappings with encryption support
- Network interface configuration
- IMDSv2 enforcement
- Spot instance configuration
- CPU and credit options
- Monitoring and placement options
- Tag propagation to created resources
- Capacity reservation support
- Hibernation and enclave options

## Usage

### Basic Launch Template

```hcl
module "launch_template" {
  source = "../../modules/aws/compute/launch-template"

  name        = "web-server-template"
  description = "Launch template for web servers"

  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"
  key_name      = "my-key-pair"

  iam_instance_profile = aws_iam_instance_profile.web_server.name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF
  )

  # Root volume configuration
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 30
        volume_type           = "gp3"
        iops                  = 3000
        throughput            = 125
        encrypted             = true
        delete_on_termination = true
      }
    }
  ]

  # Network configuration
  network_interfaces = [
    {
      device_index                = 0
      associate_public_ip_address = false
      delete_on_termination       = true
      security_groups             = [aws_security_group.web.id]
    }
  ]

  # Enforce IMDSv2
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_monitoring = true

  # Propagate tags to instances and volumes
  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Application = "web"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Backup = "daily"
      }
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

### Spot Instance Launch Template

```hcl
module "spot_launch_template" {
  source = "../../modules/aws/compute/launch-template"

  name        = "spot-worker-template"
  description = "Launch template for Spot workers"

  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "c5.xlarge"

  # Spot instance configuration
  instance_market_options = {
    market_type = "spot"
    spot_options = {
      max_price                      = "0.10"
      spot_instance_type             = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 50
        volume_type           = "gp3"
        encrypted             = true
        delete_on_termination = true
      }
    }
  ]

  network_interfaces = [
    {
      device_index          = 0
      delete_on_termination = true
      security_groups       = [aws_security_group.worker.id]
    }
  ]

  metadata_options = {
    http_tokens = "required"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        InstanceType = "spot"
      }
    }
  ]

  tags = {
    Environment = "production"
    CostOptimized = "true"
  }
}
```

### Burstable Instance with Unlimited Credits

```hcl
module "burstable_template" {
  source = "../../modules/aws/compute/launch-template"

  name          = "burstable-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.large"

  credit_specification = {
    cpu_credits = "unlimited"
  }

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size = 20
        volume_type = "gp3"
        encrypted   = true
      }
    }
  ]

  network_interfaces = [
    {
      device_index    = 0
      security_groups = [aws_security_group.app.id]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

### Advanced Configuration with Custom CPU Options

```hcl
module "advanced_template" {
  source = "../../modules/aws/compute/launch-template"

  name          = "advanced-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "c5.9xlarge"

  # Custom CPU configuration (disable hyper-threading)
  cpu_options = {
    core_count       = 18
    threads_per_core = 1
  }

  # Placement configuration
  placement = {
    tenancy           = "default"
    availability_zone = "us-east-1a"
  }

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size = 100
        volume_type = "gp3"
        iops        = 10000
        throughput  = 500
        encrypted   = true
      }
    }
  ]

  disable_api_termination = true
  ebs_optimized          = true
  enable_monitoring      = true

  tags = {
    Environment = "production"
    CriticalApp = "true"
  }
}
```

## Tag Specifications Resource Types

- **instance**: Tags for EC2 instances
- **volume**: Tags for EBS volumes
- **network-interface**: Tags for network interfaces
- **spot-instances-request**: Tags for Spot instance requests

## Metadata Options (IMDSv2)

| Option | Description | Recommended Value |
|--------|-------------|-------------------|
| http_endpoint | Enable/disable IMDS | `"enabled"` |
| http_tokens | IMDSv1 or IMDSv2 | `"required"` (IMDSv2) |
| http_put_response_hop_limit | Max hops for metadata | `1` |
| instance_metadata_tags | Enable instance tags in metadata | `"enabled"` |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the launch template | `string` | n/a | yes |
| image_id | AMI ID | `string` | `null` | no |
| instance_type | Instance type | `string` | `null` | no |
| user_data | Base64-encoded user data | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| launch_template_id | ID of the launch template |
| launch_template_arn | ARN of the launch template |
| launch_template_latest_version | Latest version number |
