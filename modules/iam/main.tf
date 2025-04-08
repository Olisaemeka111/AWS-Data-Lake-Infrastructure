resource "aws_iam_role" "data_lake" {
  name = "${var.project_name}-data-lake-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "glue.amazonaws.com",
            "athena.amazonaws.com",
            "kinesis.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-data-lake-role-${var.environment}"
    }
  )
}

resource "aws_iam_role_policy" "data_lake" {
  name = "${var.project_name}-data-lake-policy-${var.environment}"
  role = aws_iam_role.data_lake.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-data-lake-${var.environment}",
          "arn:aws:s3:::${var.project_name}-data-lake-${var.environment}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "athena:*",
          "kinesis:*"
        ]
        Resource = "*"
      }
    ]
  })
} 