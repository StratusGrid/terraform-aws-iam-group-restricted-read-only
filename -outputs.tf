output "iam_group_id" {
  description = "ID of IAM Group created"
  value       = aws_iam_group.group.id
}

output "iam_role_arn" {
  description = "ARN of IAM role created"
  value       = aws_iam_role.this.arn
}

output "iam_role_assumption_url" {
  description = "URL to assume role in Console"
  value       = "https://signin.aws.amazon.com/switchrole?account=${data.aws_caller_identity.current.account_id}&roleName=${aws_iam_role.this.name}&displayName=${aws_iam_role.this.name}"
}
