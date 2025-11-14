# EC2 Instance Module

This module creates an AWS EC2 instance with comprehensive configuration options including block devices, metadata options, and network settings.

## Features

- Flexible instance configuration
- Multiple block device support (root, EBS, ephemeral)
- IMDSv2 enforcement for security
- User data support (plain and base64)
- CPU configuration options
- Burstable instance credit options
- Detailed monitoring
- Termination protection
- Comprehensive tagging

## Usage

```hcl
module "ec2_instance" {
  source = "../../modules/aws/compute/ec2-instance"

  instance_name = "web-server-01"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.small"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.web.id]

  iam_instance_profile = aws_iam_instance_profile.web_server.name
  key_name             = "my-key-pair"

  associate_public_ip_address = false

  # User data for initialization
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  # Root volume configuration
  root_block_device = {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs.arn
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
  }

  # Additional EBS volumes
  ebs_block_devices = [
    {
      device_name           = "/dev/sdf"
      volume_size           = 100
      volume_type           = "gp3"
      encrypted             = true
      kms_key_id            = aws_kms_key.ebs.arn
      delete_on_termination = true
    }
  ]

  # Enforce IMDSv2 for security
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_detailed_monitoring = true
  disable_api_termination    = true

  tags = {
    Environment = "production"
    Application = "web"
  }

  volume_tags = {
    Backup = "daily"
  }
}

# Example: Burstable instance with unlimited CPU credits
module "ec2_burstable" {
  source = "../../modules/aws/compute/ec2-instance"

  instance_name = "app-server"
  ami_id        = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"

  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.app.id]

  cpu_credits = "unlimited"

  tags = {
    Type = "application"
  }
}
```

## EBS Volume Types

| Type | Description | IOPS | Throughput | Use Case |
|------|-------------|------|------------|----------|
| gp3 | General Purpose SSD | 3,000-16,000 | 125-1,000 MB/s | Most workloads |
| gp2 | General Purpose SSD | 100-16,000 | Up to 250 MB/s | Legacy general purpose |
| io2 | Provisioned IOPS SSD | 100-64,000 | Up to 1,000 MB/s | I/O intensive |
| io1 | Provisioned IOPS SSD | 100-64,000 | Up to 1,000 MB/s | Legacy I/O intensive |
| st1 | Throughput Optimized HDD | - | Up to 500 MB/s | Big data, data warehouses |
| sc1 | Cold HDD | - | Up to 250 MB/s | Infrequent access |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_name | Name of the instance | `string` | n/a | yes |
| ami_id | AMI ID | `string` | n/a | yes |
| instance_type | Instance type | `string` | `"t3.micro"` | no |
| subnet_id | Subnet ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_public_ip | Public IP address |
| instance_private_ip | Private IP address |
| instance_arn | ARN of the instance |
