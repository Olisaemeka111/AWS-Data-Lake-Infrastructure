output "data_lake_bucket_name" {
  description = "Name of the data lake bucket"
  value       = aws_s3_bucket.data_lake.id
}

output "data_lake_bucket_arn" {
  description = "ARN of the data lake bucket"
  value       = aws_s3_bucket.data_lake.arn
}

output "raw_zone_path" {
  description = "Path to the raw data zone"
  value       = "${aws_s3_bucket.data_lake.id}/raw/"
}

output "processed_zone_path" {
  description = "Path to the processed data zone"
  value       = "${aws_s3_bucket.data_lake.id}/processed/"
}

output "curated_zone_path" {
  description = "Path to the curated data zone"
  value       = "${aws_s3_bucket.data_lake.id}/curated/"
} 