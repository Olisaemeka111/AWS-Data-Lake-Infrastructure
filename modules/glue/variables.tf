variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "script_bucket" {
  description = "S3 bucket containing Glue scripts"
  type        = string
}

variable "script_path" {
  description = "Path to the Glue script in the S3 bucket"
  type        = string
}

variable "glue_version" {
  description = "Version of Glue to use"
  type        = string
  default     = "3.0"
}

variable "worker_type" {
  description = "Type of worker to use for the Glue job"
  type        = string
  default     = "G.1X"
}

variable "number_of_workers" {
  description = "Number of workers to use for the Glue job"
  type        = number
  default     = 2
}

variable "timeout" {
  description = "Timeout for the Glue job in minutes"
  type        = number
  default     = 2880
}

variable "max_concurrent_runs" {
  description = "Maximum number of concurrent runs for the Glue job"
  type        = number
  default     = 1
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