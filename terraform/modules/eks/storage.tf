resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  resolved_audio_bucket_name = var.audio_bucket_name != "" ? var.audio_bucket_name : "${var.name_prefix}-${var.environment}-audio-${random_id.bucket_suffix.hex}"
}

resource "aws_kms_key" "audio" {
  description             = "KMS key for Mixtapes audio objects"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  tags                    = local.tags
}

resource "aws_kms_alias" "audio" {
  name          = "alias/${local.name}-audio"
  target_key_id = aws_kms_key.audio.key_id
}

resource "aws_s3_bucket" "audio" {
  bucket        = local.resolved_audio_bucket_name
  force_destroy = false
  tags          = local.tags
}

resource "aws_s3_bucket_public_access_block" "audio" {
  bucket                  = aws_s3_bucket.audio.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "audio" {
  bucket = aws_s3_bucket.audio.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "audio" {
  bucket = aws_s3_bucket.audio.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audio" {
  bucket = aws_s3_bucket.audio.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.audio.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "audio" {
  bucket = aws_s3_bucket.audio.id

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  dynamic "rule" {
    for_each = var.audio_retention_days > 0 ? [1] : []
    content {
      id     = "expire-noncurrent-versions"
      status = "Enabled"
      filter {}
      noncurrent_version_expiration {
        noncurrent_days = var.audio_retention_days
      }
    }
  }
}

resource "aws_cloudfront_origin_access_control" "audio" {
  name                              = "${local.name}-audio-oac"
  description                       = "Private S3 origin for Mixtapes audio"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "audio" {
  enabled         = true
  comment         = "Mixtapes private audio distribution (${var.environment})"
  price_class     = "PriceClass_100"
  is_ipv6_enabled = true
  http_version    = "http2and3"

  origin {
    domain_name              = aws_s3_bucket.audio.bucket_regional_domain_name
    origin_id                = "private-audio-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.audio.id
  }

  default_cache_behavior {
    target_origin_id       = "private-audio-s3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags
}

data "aws_iam_policy_document" "audio_bucket" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.audio.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.audio.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "audio" {
  bucket = aws_s3_bucket.audio.id
  policy = data.aws_iam_policy_document.audio_bucket.json

  depends_on = [aws_s3_bucket_public_access_block.audio]
}
