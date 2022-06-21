resource "aws_iam_policy" "this" {
  name        = "${var.group_name}-policy"
  description = "Policy to restrict read only users. This makes it so the read only users can't do some tasks like downloading s3 bucket objects and lambda code."
  policy      = data.aws_iam_policy_document.deny_data_retrieval.json
}

