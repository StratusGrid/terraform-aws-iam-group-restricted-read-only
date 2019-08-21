data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "read_only_access" {
  group      = aws_iam_group.group.name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}

resource "aws_iam_role_policy_attachment" "read_only_access" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}

