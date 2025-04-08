# AWS Region and Environment
aws_region = "us-west-2"
environment = "dev"

# Project Configuration
project_name = "data-lake"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

# S3 Configuration
kms_key_arn = "arn:aws:kms:us-east-1:156041437006:key/6d8803c1-e916-40d5-8fd9-2fe6ff866c5b"

# Kinesis Configuration
sns_topic_arn = "arn:aws:sns:us-east-1:156041437006:data-lake-notifications"

# Resource Tags
tags = {
  Project     = "data-lake"
  ManagedBy   = "terraform"
  Environment = "dev"
  Owner       = "data-team"
  CostCenter  = "data-analytics"
  Application = "data-lake"
  Service     = "analytics"
} 