resource "aws_s3_bucket" "static_site" {
  bucket        = "rumo-a-procedencia-landing-page"
  force_destroy = true

  tags = {
    Environment = "production"
    Owner       = "Gustavo"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "public_read" {
  bucket = aws_s3_bucket.static_site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}
resource "aws_s3_bucket_lifecycle_configuration" "version_expiry" {
  bucket = aws_s3_bucket.static_site.id

  rule {
    id     = "LimitTo5Versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    noncurrent_version_transition {
      storage_class   = "GLACIER"
      noncurrent_days = 7
    }
  }
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
