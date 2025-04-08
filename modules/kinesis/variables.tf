variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "shard_count" {
  description = "Number of shards in the Kinesis stream"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "Retention period of the Kinesis stream in hours"
  type        = number
  default     = 24
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 