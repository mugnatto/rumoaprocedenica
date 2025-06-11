resource "aws_sns_topic" "site_topic" {
  name = "${var.bucket_name}-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.site_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn = aws_sns_topic.site_topic.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "s3.amazonaws.com" },
        Action    = "sns:Publish",
        Resource  = aws_sns_topic.site_topic.arn
      }
    ]
  })
}

resource "aws_s3_bucket" "static_site" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Environment = "production"
    Owner       = "Gustavo"
  }
}


resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.static_site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          "${aws_s3_bucket.static_site.arn}",
          "${aws_s3_bucket.static_site.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.static_site.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "version_expiry" {
  bucket = aws_s3_bucket.static_site.id

  rule {
    id     = "LimitTo5Versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    noncurrent_version_transition {
      storage_class   = "GLACIER"
      noncurrent_days = 7
    }
  }
}
resource "aws_s3_bucket_notification" "s3_notification" {
  bucket = aws_s3_bucket.static_site.id

  topic {
    events    = ["s3:ObjectCreated:*"]
    topic_arn = aws_sns_topic.site_topic.arn
  }

  depends_on = [aws_s3_bucket.static_site]
}

output "s3_site_url" {
  description = "URL pública do site estático S3"
  value       = "http://${var.bucket_name}.s3-website-${var.region}.amazonaws.com"
}
