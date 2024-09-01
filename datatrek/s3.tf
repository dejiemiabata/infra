resource "aws_s3_bucket" "s3_datatrek_bucket" {
  bucket = var.bucket_name
  tags = {
    Environment = "Development"
  }
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3_datatrek_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "s3_datatrek_bucket" {
  bucket = aws_s3_bucket.s3_datatrek_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.iam_user_name}_s3_access_policy"
  description = "Policy to allow S3 access to a user"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "${aws_s3_bucket.s3_datatrek_bucket.arn}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.s3_datatrek_bucket.arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = var.iam_user_name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
