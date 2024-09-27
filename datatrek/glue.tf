resource "aws_glue_catalog_database" "datatrek_glue_database" {
  name        = "location_db"
  description = "Glue Location Database for DataTrek"
}

resource "aws_iam_policy" "glue_access_policy" {
  name        = "${var.iam_user_name}_glue_access_policy"
  description = "Policy to allow Glue access to a user"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowGlueCatalogTableAccess",
        "Effect" : "Allow",
        "Action" : [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:GetUserDefinedFunction",
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:BatchCreatePartition",
          "glue:BatchDeletePartition"
        ],
        "Resource" : [
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_glue_catalog_database.datatrek_glue_database.name}/*",
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${aws_glue_catalog_database.datatrek_glue_database.name}"
        ]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "glue_user_policy_attachment" {
  user       = var.iam_user_name
  policy_arn = aws_iam_policy.glue_access_policy.arn
}


# Get the current AWS region
data "aws_region" "current" {}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}