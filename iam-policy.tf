data "aws_iam_policy_document" "this" {
  statement {
    sid = "DenyReadOnlyDataRetrieval"
    effect = "Deny"
    actions = [
      "s3:GetObject",
      "lambda:GetFunction",
      "workdocs:Get*",
      "workmail:Get*",
      "athena:GetQueryResults*",
    ]
    not_resources = var.s3_bucket_paths_to_allow
  }
  statement {
    sid = "DenyReadOnlySecrets"
    effect = "Deny"
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameter*",
      "ecr:GetAuthorizationToken",
      "ec2:GetPasswordData",
      "redshift:GetClusterCredentials",
      "cognito-identity:GetCredentialsForIdentity",
      "cognito-identity:GetId",
      "cognito-identity:GetOpenIdToken",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.group_name}-policy"
  description = "Policy to restrict read only users. This makes it so the read only users can't do some tasks like downloading s3 bucket objects and lambda code."
  policy      = data.aws_iam_policy_document.this.json
}

