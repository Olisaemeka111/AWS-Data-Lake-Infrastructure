# AWS Data Lake Infrastructure

This repository contains Terraform configurations for deploying a complete AWS Data Lake infrastructure.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                               AWS Data Lake                                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                               VPC (10.0.0.0/16)                            │
│                                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │  Public     │  │  Public     │  │  Public     │  │  Internet   │       │
│  │  Subnet     │  │  Subnet     │  │  Subnet     │◄──┤  Gateway    │       │
│  │  (10.0.48/20)│  │  (10.0.64/20)│  │  (10.0.80/20)│  │             │       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────────────┘       │
│         │                │                │                               │
│         ▼                ▼                ▼                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                       │
│  │  NAT        │  │  NAT        │  │  NAT        │                       │
│  │  Gateway    │  │  Gateway    │  │  Gateway    │                       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                       │
│         │                │                │                               │
│         ▼                ▼                ▼                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                       │
│  │  Private    │  │  Private    │  │  Private    │                       │
│  │  Subnet     │  │  Subnet     │  │  Subnet     │                       │
│  │  (10.0.0/20) │  │  (10.0.16/20)│  │  (10.0.32/20)│                       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                       │
│         │                │                │                               │
│         └────────────────┼────────────────┘                               │
│                          │                                                  │
│                          ▼                                                  │
│  ┌─────────────────────────────────────────────────────────────┐           │
│  │  VPC Endpoints                                             │           │
│  │  - S3 Gateway Endpoint                                     │           │
│  │  - Kinesis Interface Endpoint                              │           │
│  └─────────────────────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                               Data Lake Components                          │
│                                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │  S3 Data    │  │  Kinesis    │  │  Glue       │  │  Athena     │       │
│  │  Lake       │  │  Stream     │  │  ETL        │  │  Query      │       │
│  │             │  │             │  │  Engine     │  │  Engine     │       │
│  │  - Raw      │  │  - Stream   │  │  - Job      │  │  - Workgroup│       │
│  │  - Processed│  │  - Consumer │  │  - Database │  │  - Database │       │
│  │  - Curated  │  │  - Alarms   │  │  - Crawler  │  │  - Named    │       │
│  │             │  │             │  │             │  │    Query    │       │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘       │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Components

### Networking
- VPC with CIDR block 10.0.0.0/16
- 3 public subnets and 3 private subnets across multiple availability zones
- Internet Gateway for public internet access
- NAT Gateways for private subnet internet access
- VPC Endpoints for S3 and Kinesis services
- Security groups for VPC endpoints
- Flow logs for network traffic monitoring

### S3 Data Lake
- S3 bucket with versioning enabled
- Server-side encryption using KMS
- Intelligent tiering for cost optimization
- Lifecycle rules for data management
- Data lake zones:
  - Raw: For storing original, unmodified data
  - Processed: For storing transformed data
  - Curated: For storing business-ready data

### Kinesis Stream
- Kinesis stream for real-time data ingestion
- Stream consumer for data processing
- CloudWatch alarms for monitoring stream metrics

### Glue ETL
- Glue ETL job for data transformation
- Glue catalog database for metadata management
- Glue crawler for automatic schema discovery
- IAM roles and policies for Glue service

### Athena
- Athena workgroup for query execution
- Named query for common data access patterns
- S3 bucket for query results
- IAM roles and policies for Athena service

### IAM
- IAM roles and policies for service access control
- Service roles for Glue, Athena, and Kinesis

## Usage

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0.0)

### Deployment
1. Update the `terraform.tfvars` file with your specific values
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Apply the configuration:
   ```
   terraform apply
   ```

### Environment Variables
- `aws_region`: AWS region for deployment
- `environment`: Environment name (dev, staging, prod)
- `project_name`: Name of the project
- `vpc_cidr`: CIDR block for VPC
- `availability_zones`: List of availability zones
- `kms_key_arn`: ARN of the KMS key for encryption
- `sns_topic_arn`: ARN of the SNS topic for notifications
- `log_retention_days`: Number of days to retain logs

## Security
- All S3 buckets have public access blocked
- Server-side encryption using KMS for all data
- VPC endpoints for secure service access
- IAM roles with least privilege principle
- TLS enforcement for S3 access

## Monitoring
- CloudWatch logs for all services
- CloudWatch alarms for Kinesis metrics
- VPC flow logs for network monitoring

## Cost Optimization
- S3 intelligent tiering for storage cost optimization
- Lifecycle rules for data retention management
- NAT gateways in multiple AZs for high availability

## License
This project is licensed under the MIT License - see the LICENSE file for details. # AWS-Data-Lake-Infrastructure
