data "aws_iam_policy_document" "user_self_service_policy" {
  statement {
    sid = "ListUsersAccessWithoutMFA"

    actions = [
      "iam:ListVirtualMFADevices"
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }

  statement {
    sid = "SelfServiceAccessWithoutMFA"

    actions = [
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:ChangePassword",
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:iam::*:user/$${aws:username}",
      "arn:aws:iam::*:mfa/$${aws:username}"
    ]
  }

  statement {
    sid = "SelfServiceAccessWithMFA"

    actions = [
        "iam:Get*",
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey",
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:UpdateAccessKey",
        "iam:DeleteVirtualMFADevice",
        "iam:DeactivateMFADevice",
        "iam:ResyncMFADevice",
        "iam:UploadSigningCertificate",
        "iam:UpdateSigningCertificate",
        "iam:DeleteSigningCertificate",
        "iam:GenerateServiceLastAccessedDetails"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:iam::*:user/$${aws:username}",
      "arn:aws:iam::*:mfa/$${aws:username}"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true"
      ]
    }
  }

  statement {
    sid = "DenyAllExceptListedIfNoMFA"

    not_actions = [
        "iam:ListVirtualMFADevices",
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:EnableMFADevice",
        "iam:CreateVirtualMFADevice",
        "iam:ChangePassword"
    ]

    effect = "Deny"

    resources = [
        "*"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "false"
      ]
    }
  }
}

data "aws_iam_policy_document" "role_assumption" {
  statement {
    sid = "AssumeRole"

    actions = [
        "sts:AssumeRole"
    ]

    effect = "Allow"

    resources = [
      "${aws_iam_role.this.arn}"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true"
      ]
    }
  }
}

data "aws_iam_policy_document" "deny_data_retrieval" {
  statement {
    sid = "DenyReadOnlyDataRetrieval"
    effect = "Deny"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionForReplication",
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