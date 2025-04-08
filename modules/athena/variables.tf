variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "database_name" {
  description = "Name of the Glue database"
  type        = string
}

variable "table_name" {
  description = "Name of the Glue table"
  type        = string
}

variable "query_results_bucket" {
  description = "Name of the S3 bucket for Athena query results"
  type        = string
}

variable "query_results_bucket_arn" {
  description = "ARN of the S3 bucket for Athena query results"
  type        = string
}

variable "data_bucket_arn" {
  description = "ARN of the S3 bucket containing the data"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 