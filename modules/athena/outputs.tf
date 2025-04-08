output "workgroup_name" {
  description = "Name of the Athena workgroup"
  value       = aws_athena_workgroup.main.name
}

output "workgroup_arn" {
  description = "ARN of the Athena workgroup"
  value       = aws_athena_workgroup.main.arn
}

output "named_query_id" {
  description = "ID of the Athena named query"
  value       = aws_athena_named_query.example.id
}

output "query_results_bucket_name" {
  description = "Name of the S3 bucket for query results"
  value       = aws_s3_bucket.query_results.id
}

output "query_results_bucket_arn" {
  description = "ARN of the S3 bucket for query results"
  value       = aws_s3_bucket.query_results.arn
}

output "athena_role_arn" {
  description = "ARN of the IAM role for Athena"
  value       = aws_iam_role.athena.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for Athena"
  value       = aws_cloudwatch_log_group.athena.name
}

output "database_name" {
  description = "Name of the Athena database"
  value       = aws_athena_database.main.name
} 