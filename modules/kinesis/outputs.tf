output "stream_arn" {
  description = "ARN of the Kinesis stream"
  value       = aws_kinesis_stream.main.arn
}

output "stream_name" {
  description = "Name of the Kinesis stream"
  value       = aws_kinesis_stream.main.name
}

output "consumer_arn" {
  description = "ARN of the Kinesis stream consumer"
  value       = aws_kinesis_stream_consumer.main.arn
} 