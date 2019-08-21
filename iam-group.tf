resource "aws_iam_group" "group" {
  name = var.group_name
  path = var.group_path
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_policy" "role_assumption" {
  name  = "${var.group_name}-role-assumption-policy"
  group = aws_iam_group.group.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.this.arn}",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF

}

resource "aws_iam_group_policy" "user_self_service" {
  name  = "${var.group_name}-user-self-service-policy"
  group = aws_iam_group.group.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListUsersAccessWithoutMFA",
      "Action": [
        "iam:ListVirtualMFADevices"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "SelfServiceAccessWithoutMFA",
      "Action": [
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:ChangePassword",
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:user/$${aws:username}",
        "arn:aws:iam::*:mfa/$${aws:username}"
      ]
    },
    {
      "Sid": "SelfServiceAccessWithMFA",
      "Effect": "Allow",
      "Action": [
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
      ],
      "Resource": [
        "arn:aws:iam::*:user/$${aws:username}",
        "arn:aws:iam::*:mfa/$${aws:username}"
      ],
      "Condition": {"BoolIfExists": {"aws:MultiFactorAuthPresent": true}}
    },
    {
      "Sid": "DenyAllExceptListedIfNoMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:ListVirtualMFADevices",
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:EnableMFADevice",
        "iam:CreateVirtualMFADevice",
        "iam:ChangePassword"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
EOF

}
