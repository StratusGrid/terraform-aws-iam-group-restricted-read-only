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

  policy = data.aws_iam_policy_document.role_assumption

}

resource "aws_iam_group_policy" "user_self_service" {
  name  = "${var.group_name}-user-self-service-policy"
  group = aws_iam_group.group.id

  policy = data.aws_iam_policy_document.user_self_service_policy
}
