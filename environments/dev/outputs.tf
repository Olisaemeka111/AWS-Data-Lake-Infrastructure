output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "vpc_endpoint_s3_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = module.networking.vpc_endpoint_s3_id
}

output "vpc_endpoint_kinesis_id" {
  description = "The ID of the Kinesis VPC endpoint"
  value       = module.networking.vpc_endpoint_kinesis_id
}

output "data_lake_bucket_name" {
  description = "Name of the S3 data lake bucket"
  value       = module.s3.data_lake_bucket_name
}

output "data_lake_bucket_arn" {
  description = "ARN of the S3 data lake bucket"
  value       = module.s3.data_lake_bucket_arn
}

output "raw_zone_path" {
  description = "Path to the raw data zone"
  value       = module.s3.raw_zone_path
}

output "processed_zone_path" {
  description = "Path to the processed data zone"
  value       = module.s3.processed_zone_path
}

output "curated_zone_path" {
  description = "Path to the curated data zone"
  value       = module.s3.curated_zone_path
}

output "kinesis_stream_name" {
  description = "Name of the Kinesis stream"
  value       = module.kinesis.stream_name
}

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream"
  value       = module.kinesis.stream_arn
}

output "kinesis_consumer_arn" {
  description = "The ARN of the Kinesis stream consumer"
  value       = module.kinesis.consumer_arn
}

output "glue_job_name" {
  description = "Name of the Glue ETL job"
  value       = module.glue.job_name
}

output "glue_database_name" {
  description = "Name of the Glue database"
  value       = module.glue.database_name
}

output "glue_crawler_name" {
  description = "The name of the Glue crawler"
  value       = module.glue.crawler_name
}

output "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  value       = module.athena.workgroup_name
} 