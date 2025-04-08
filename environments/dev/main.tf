provider "aws" {
  region = var.aws_region
}

# VPC and Networking
module "networking" {
  source = "../../modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  aws_region          = var.aws_region
  enable_vpc_endpoints = true
  enable_flow_logs    = true
  retention_days      = var.log_retention_days
  tags                = var.tags
}

# S3 Data Lake
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = var.kms_key_arn
  tags         = var.tags
}

# Kinesis Stream
module "kinesis" {
  source = "../../modules/kinesis"

  project_name   = var.project_name
  environment    = var.environment
  sns_topic_arn = var.sns_topic_arn
  tags          = var.tags
}

# Glue ETL
module "glue" {
  source = "../../modules/glue"

  project_name = var.project_name
  environment  = var.environment
  s3_bucket_arn      = module.s3.data_lake_bucket_arn
  s3_bucket_name     = module.s3.data_lake_bucket_name
  script_bucket      = "${var.project_name}-scripts-${var.environment}"
  script_path        = "glue/etl_job.py"
  glue_version       = "3.0"
  worker_type        = "G.1X"
  number_of_workers  = 2
  timeout            = 2880
  max_concurrent_runs = 1
  log_retention_days = var.log_retention_days
  tags               = var.tags
}

# Athena
module "athena" {
  source = "../../modules/athena"

  project_name = var.project_name
  environment  = var.environment
  database_name             = module.glue.database_name
  table_name                = "example_table"
  query_results_bucket      = "${var.project_name}-query-results-${var.environment}"
  query_results_bucket_arn  = "arn:aws:s3:::${var.project_name}-query-results-${var.environment}"
  data_bucket_arn          = module.s3.data_lake_bucket_arn
  kms_key_arn              = var.kms_key_arn
  log_retention_days       = var.log_retention_days
  tags                     = var.tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
} 