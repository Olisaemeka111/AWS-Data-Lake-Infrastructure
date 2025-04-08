# Athena Workgroup
resource "aws_athena_workgroup" "main" {
  name = "${var.project_name}-workgroup-${var.environment}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${var.project_name}-data-lake-${var.environment}/athena-results/"
      
      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn      = var.kms_key_arn
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-workgroup-${var.environment}"
    }
  )
}

# Athena Named Query
resource "aws_athena_named_query" "example" {
  name        = "${var.project_name}-example-query"
  workgroup   = aws_athena_workgroup.main.name
  database    = var.database_name
  description = "Example query for ${var.project_name}"
  query       = <<EOF
SELECT *
FROM "${var.database_name}"."${var.table_name}"
LIMIT 10;
EOF
}

# IAM Role for Athena
resource "aws_iam_role" "athena" {
  name = "${var.project_name}-athena-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "athena.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Athena
resource "aws_iam_role_policy" "athena" {
  name = "${var.project_name}-athena-policy"
  role = aws_iam_role.athena.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          var.query_results_bucket_arn,
          "${var.query_results_bucket_arn}/*",
          var.data_bucket_arn,
          "${var.data_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersion",
          "glue:GetTableVersions",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetPartition",
          "glue:GetPartitions"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# S3 Bucket for Query Results
resource "aws_s3_bucket" "query_results" {
  bucket = var.query_results_bucket

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-query-results"
    }
  )
}

resource "aws_s3_bucket_versioning" "query_results" {
  bucket = aws_s3_bucket.query_results.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "query_results" {
  bucket = aws_s3_bucket.query_results.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "query_results" {
  bucket = aws_s3_bucket.query_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch Log Group for Athena
resource "aws_cloudwatch_log_group" "athena" {
  name              = "/aws/athena/${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_athena_database" "main" {
  name   = replace("${var.project_name}_${var.environment}", "-", "_")
  bucket = "${var.project_name}-data-lake-${var.environment}"
} 