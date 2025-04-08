output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.data_lake.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.data_lake.name
} 