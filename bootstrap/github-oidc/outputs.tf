output "plan_role_arn" {
  description = "Set this as the AWS_PLAN_ROLE_ARN secret in the aws-plan environment."
  value       = aws_iam_role.plan.arn
}

output "apply_role_arn" {
  description = "Set this as the AWS_APPLY_ROLE_ARN secret in the aws-apply environment."
  value       = aws_iam_role.apply.arn
}

output "plan_subject" {
  description = "Immutable GitHub OIDC subject trusted by the plan role."
  value       = "${local.repository_subject_prefix}aws-plan"
}

output "apply_subject" {
  description = "Immutable GitHub OIDC subject trusted by the apply role."
  value       = "${local.repository_subject_prefix}aws-apply"
}
