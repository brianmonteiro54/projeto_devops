# CloudTrail Configuration
resource "aws_cloudtrail" "cloudtrail_monitor" {
  depends_on = [aws_s3_bucket_policy.cloudtrail_bucket_policy]

  name                          = "cloudtrail-monitor"
  s3_bucket_name                = aws_s3_bucket.auditoria-conta.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

# Define the S3 Bucket for CloudTrail logs
resource "aws_s3_bucket" "auditoria-conta" {
  bucket_prefix = "cloudtrail-auditoria"
  force_destroy = true
}

# IAM Policy Document for S3 Bucket Policy
data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.auditoria-conta.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloudtrail-monitor"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.auditoria-conta.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloudtrail-monitor"]
    }
  }
}

# S3 Bucket Policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.auditoria-conta.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
}