variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  sensitive   = true
}

variable "iam_user_name" {
  description = "The IAM username"
  type        = string
  sensitive   = true
}
