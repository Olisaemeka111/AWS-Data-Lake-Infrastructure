# Glue Job Role
resource "aws_iam_role" "glue_job" {
  name = "${var.project_name}-glue-job-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Glue Job Role Policy
resource "aws_iam_role_policy" "glue_job" {
  name = "${var.project_name}-glue-job-policy"
  role = aws_iam_role.glue_job.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersion",
          "glue:GetTableVersions",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase"
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

# Glue Job
resource "aws_glue_job" "etl" {
  name              = "${var.project_name}-etl-job"
  role_arn          = aws_iam_role.glue_job.arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  timeout           = var.timeout

  command {
    script_location = "s3://${var.script_bucket}/${var.script_path}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"            = "python"
    "--continuous-log-logGroup" = "/aws-glue/jobs/${var.project_name}-etl-job"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"          = "true"
    "--enable-spark-ui"         = "true"
    "--spark-event-logs-path"   = "s3://${var.script_bucket}/spark-logs/"
    "--enable-job-insights"     = "true"
    "--job-bookmark-option"     = "job-bookmark-enable"
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  tags = var.tags
}

# Glue Database
resource "aws_glue_catalog_database" "data_lake" {
  name = "${var.project_name}-database-${var.environment}"
}

# Glue Crawler
resource "aws_glue_crawler" "data_lake" {
  database_name = aws_glue_catalog_database.data_lake.name
  name          = "${var.project_name}-crawler-${var.environment}"
  role          = aws_iam_role.glue_crawler.arn

  s3_target {
    path = "s3://${var.project_name}-data-lake-${var.environment}/raw/"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-crawler-${var.environment}"
    }
  )
}

# CloudWatch Log Group for Glue Job
resource "aws_cloudwatch_log_group" "glue_job" {
  name              = "/aws-glue/jobs/${var.project_name}-etl-job"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_iam_role" "glue_crawler" {
  name = "${var.project_name}-glue-crawler-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-glue-crawler-role-${var.environment}"
    }
  )
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_crawler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3" {
  name = "${var.project_name}-glue-s3-policy-${var.environment}"
  role = aws_iam_role.glue_crawler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-data-lake-${var.environment}/*"
        ]
      }
    ]
  })
} 