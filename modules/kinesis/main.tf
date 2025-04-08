# Kinesis Stream
resource "aws_kinesis_stream" "main" {
  name             = "${var.project_name}-stream-${var.environment}"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-stream-${var.environment}"
    }
  )
}

# Kinesis Stream Consumer
resource "aws_kinesis_stream_consumer" "main" {
  name       = "${var.project_name}-consumer-${var.environment}"
  stream_arn = aws_kinesis_stream.main.arn
}

# CloudWatch Alarm for Kinesis Stream Metrics
resource "aws_cloudwatch_metric_alarm" "kinesis_write_throughput" {
  alarm_name          = "${var.project_name}-kinesis-write-throughput-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "WriteProvisionedThroughputExceeded"
  namespace           = "AWS/Kinesis"
  period             = "300"
  statistic          = "Average"
  threshold          = "0"
  alarm_description  = "Kinesis stream write throughput exceeded"
  alarm_actions      = [var.sns_topic_arn]

  dimensions = {
    StreamName = aws_kinesis_stream.main.name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-kinesis-alarm-${var.environment}"
    }
  )
} 