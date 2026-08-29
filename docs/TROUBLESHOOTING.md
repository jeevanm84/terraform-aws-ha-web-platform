# Troubleshooting

Work from the earliest failing stage. Do not solve authentication errors by creating long-lived access keys in GitHub.

## `terraform init` asks for an S3 bucket

For offline work, use:

```bash
terraform -chdir=environments/learning init -backend=false
```

For a real environment, bootstrap state and pass both backend values as shown in the end-to-end guide.

## Unsupported Terraform version

The native S3 lockfile configuration requires Terraform 1.10 or newer. Confirm with `terraform version`, update Terraform, and rerun initialization.

## Mock tests try to authenticate to AWS

Run tests from `environments/learning`, make sure Terraform is current, and verify `tests/platform.tftest.hcl` still declares `mock_provider "aws"`. The repository check script uses no backend and needs no AWS environment variables.

## Fewer than two Availability Zones

Choose a normal commercial region with at least two available AZs. Mock tests provide three synthetic zones and are unaffected.

## OIDC `Not authorized to perform sts:AssumeRoleWithWebIdentity`

Check, in order:

1. The workflow job references the exact `aws-plan` or `aws-apply` environment.
2. The role ARN is stored in that environment, not copied into code.
3. The trust subject contains the current visible owner/repository names and immutable numeric IDs.
4. The OIDC audience is `sts.amazonaws.com`.
5. A repository rename/transfer has not made the trust condition stale.

## Backend `AccessDenied` or lock errors

Both plan and apply roles need read/write/delete access to the state object and `.tflock` object. Confirm the bucket name, region, key prefix, and state policy. Do not disable locking to bypass an active operation; find the owner of the lock first.

## ALB targets remain unhealthy

Check the instance user-data log, nginx status, target-group `/health` path, application port, and compute security-group rule. Instances need outbound access to install nginx; verify NAT route and gateway status.

## Destroy fails on RDS deletion protection

Set `database_deletion_protection = false`, apply that single change, then rerun destroy. If final snapshots are enabled, ensure the identifier is available and your role can create snapshots.

## A workflow is skipped

Apply runs only when the confirmation input is exactly `APPLY`; destroy requires exactly `DESTROY`. Protected environments can also wait for an authorized reviewer.

When opening an issue, sanitize logs. Never include credentials, state JSON, plan files, repository secrets, AWS account IDs, or database endpoints.
