output "iam_group_id" {
  description = "ID of IAM Group created"
  value       = aws_iam_group.group.id
}

output "iam_role_arn" {
  description = "ARN of IAM Group created"
  value       = aws_iam_group.group.arn
}

