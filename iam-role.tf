resource "aws_iam_role" "this" {
  name               = "${var.group_name}-role"
  tags               = local.common_tags
  assume_role_policy = data.aws_iam_policy_document.cross_account_assume_role_policy_mfa.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "cross_account_assume_role_policy_mfa" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values = [
        "true",
      ]
    }
  }
}

