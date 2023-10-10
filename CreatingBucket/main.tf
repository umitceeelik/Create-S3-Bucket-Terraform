# To create Origin bucket
resource "aws_s3_bucket" "OriginBucket" {
    bucket = var.bucketName_origin
}

# To create Logs bucket
resource "aws_s3_bucket" "LogsBucket" {
    bucket = var.bucketName_logs
}

# To activate logs bucket ownership control acl enabled
resource "aws_s3_bucket_ownership_controls" "LogsOwnershipControls" {
    bucket = aws_s3_bucket.LogsBucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "LogsBucket" {
    depends_on = [aws_s3_bucket_ownership_controls.LogsOwnershipControls]
    bucket = aws_s3_bucket.LogsBucket.id
    acl    = "private"
}

# To block bucket public access
resource "aws_s3_bucket_public_access_block" "Origin_bucket_public_access_block" {
  bucket = aws_s3_bucket.OriginBucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "Logs_bucket_public_access_block" {
  bucket = aws_s3_bucket.LogsBucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create Cloudfront distribution
locals {
    s3_origin_id = "${aws_s3_bucket.OriginBucket.id}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name              = aws_s3_bucket.OriginBucket.bucket_regional_domain_name
        origin_id                = local.s3_origin_id

        s3_origin_config {
            origin_access_identity = "${aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path}"
        }
    }
    enabled             = true
    is_ipv6_enabled     = true
    comment             = var.cloudfront_description
    default_root_object = "index.html"

    # Standart Logging -> on
    logging_config {
        include_cookies = true
        bucket          = aws_s3_bucket.LogsBucket.bucket_domain_name
        prefix          = ""
    }

    # To update bucket policy
    depends_on = [aws_s3_bucket_policy.bucket_policy]
    
    # Alternate domain name (CNAME) 
    aliases = [var.cloudfront_domainName]

    # Default cache behavior
    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            headers = [
                "Access-Control-Request-Headers",
                "Access-Control-Request-Method",
                "Origin",
            ]
            query_string            = false
            query_string_cache_keys = []

            cookies {
                forward           = "none"
                whitelisted_names = []
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        compress               = true
        min_ttl                = 0
        default_ttl            = 60
        max_ttl                = 31536000
    }

    price_class = "PriceClass_100"

    restrictions {
        geo_restriction {
        restriction_type = "none"
        locations        = null
        }
    }

    tags = {
    }

    viewer_certificate {
        acm_certificate_arn            = "arn:aws:acm:us-east-1:833504477311:certificate/46abd222-c5bd-4344-9d4e-d780d0ceae7d"
        cloudfront_default_certificate = false
        minimum_protocol_version       = "TLSv1.2_2021"
        ssl_support_method             = "sni-only"
    }

    # Adding Custom Error Response
    custom_error_response {
        error_code    = 404
        response_page_path = "/index.html" # Replace this with the path to your custom 404 error page in your origin bucket
        response_code = "200" # Change this to the desired response code (e.g., 200, 302, etc.)
        error_caching_min_ttl = 10 # Optional: Specify the minimum TTL for caching the error response (default: 5 minutes)
    }

    custom_error_response {
        error_code    = 403
        response_page_path = "/index.html" # Replace this with the path to your custom 403 error page in your origin bucket
        response_code = "200" # Change this to the desired response code (e.g., 200, 302, etc.)
        error_caching_min_ttl = 10 # Optional: Specify the minimum TTL for caching the error response (default: 5 minutes)
    }
}

// To create a CloudFront Origin Access Identity for this Cloudfrount distribution
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Default CloudFront Origin Access Identity"
}

// To create a bucket policy to update when creating Cloudfrount distribution
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.OriginBucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "1",
            Effect = "Allow",
            Principal = {
                AWS = aws_cloudfront_origin_access_identity.default.iam_arn
            },
            Action = "s3:GetObject",
            Resource = "${aws_s3_bucket.OriginBucket.arn}/*"
        },
        {
            Sid = "2",
            Effect = "Allow",
            Principal = {
                AWS = aws_cloudfront_origin_access_identity.default.iam_arn
            },
            Action = "s3:PutObject",
            Resource = "${aws_s3_bucket.OriginBucket.arn}/*"
        }
    ]
  })
}

# // To import a Route53 hosted zone that represents our exists atlas.space zone
# resource "aws_route53_zone" "atlas_space" {
#     name = "atlas.space"
#     # lifecycle {
#     #     prevent_destroy = true
#     # }  
# }

// To reach our imported exists atlas.space zone
data  "aws_route53_zone" "atlas_space" {
  name = "atlas.space"
  
  # Additional configuration options can be added here
}

// To create Route53 record
resource "aws_route53_record" "cdn_record" {
  name    = var.Route53_domainName
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
  zone_id = "${data.aws_route53_zone.atlas_space.id}"
}
