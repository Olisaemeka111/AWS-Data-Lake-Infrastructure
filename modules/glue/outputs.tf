output "job_name" {
  description = "Name of the Glue ETL job"
  value       = aws_glue_job.etl.name
}

output "job_arn" {
  description = "ARN of the Glue ETL job"
  value       = aws_glue_job.etl.arn
}

output "database_name" {
  description = "Name of the Glue catalog database"
  value       = aws_glue_catalog_database.data_lake.name
}

output "crawler_name" {
  description = "Name of the Glue crawler"
  value       = aws_glue_crawler.data_lake.name
}

output "glue_role_arn" {
  description = "ARN of the IAM role for Glue"
  value       = aws_iam_role.glue_job.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for Glue job"
  value       = aws_cloudwatch_log_group.glue_job.name
} 