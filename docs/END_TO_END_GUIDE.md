# End-to-end guide

This is the main learning document. Follow it in order the first time. Modules 1–5 are local and require no AWS account. Stop there safely, or continue with Modules 6–10 only after you have your own sandbox AWS account, billing alerts, and permission to create resources.

## Progress map

| Module | Goal | AWS account | Creates billable resources |
|---|---|---:|---:|
| 1 | Install and verify tools | No | No |
| 2 | Read the architecture | No | No |
| 3 | Initialize locally | No | No |
| 4 | Validate and test | No | No |
| 5 | Modify one input safely | No | No |
| 6 | Prepare an AWS sandbox | Yes | No |
| 7 | Bootstrap remote state | Yes | S3 only |
| 8 | Bootstrap GitHub OIDC | Yes | IAM only |
| 9 | Plan, apply, and verify | Yes | Yes |
| 10 | Destroy and confirm cleanup | Yes | Removes workload |

## Module 1 — install and verify tools

Install Git and Terraform `>= 1.10`. Then clone the repository:

```bash
git clone https://github.com/jeevanm84/terraform-aws-ha-web-platform.git
cd terraform-aws-ha-web-platform
./scripts/verify-tools.sh
```

Checkpoint: the script prints paths for `git` and `terraform`, then a supported Terraform version.

## Module 2 — understand the platform before running it

Read [ARCHITECTURE.md](ARCHITECTURE.md), then locate the root module:

```bash
cd environments/learning
```

Terraform starts with the root files in this directory and calls five child modules. File order does not control Terraform; references form the dependency graph.

Key decisions to identify:

1. Public subnets contain only the internet-facing load balancer and NAT gateways.
2. Web instances have no public IP and accept application traffic only from the load balancer security group.
3. Database subnets have no internet default route.
4. RDS is optional and off by default.
5. Two instances across two AZs make the compute tier genuinely redundant.

Checkpoint: you can explain the request path `internet → ALB → target group → private instance`.

## Module 3 — initialize without remote state

From `environments/learning`:

```bash
terraform init -backend=false
```

This downloads provider and module metadata. `-backend=false` deliberately avoids S3 and does not need AWS credentials.

Checkpoint: Terraform reports successful initialization and creates only a local `.terraform/` working directory.

## Module 4 — format, validate, and test without AWS

Return to the repository root and run the complete check:

```bash
cd ../..
./scripts/check.sh
```

What each stage proves:

- `terraform fmt -check` enforces a consistent style.
- `terraform validate` checks syntax, references, module inputs, and provider schemas.
- `terraform test` substitutes a mock AWS provider and evaluates two plan profiles.
- No `terraform apply` command runs, and no real AWS API is called.

Checkpoint: both test runs pass and the script confirms that no AWS resources were created.

## Module 5 — make and test a safe change

Copy the cost-aware example to a local ignored file:

```bash
cp environments/learning/learning.tfvars.example environments/learning/learning.auto.tfvars
```

Change `project_name`, instance capacity, or tags. Keep the scaling relationship valid:

```text
min_size <= desired_capacity <= max_size
```

Run `./scripts/check.sh` again. Delete the ignored local file when finished if you do not need it.

You have now completed the AWS-free learning path. The remaining modules are optional.

---

## Module 6 — prepare a safe AWS sandbox

Do not use a production or corporate account for a personal lab. Before proceeding:

- Use an account you own and are authorized to use.
- Enable MFA on the root user and administrative identity.
- Configure an AWS Budget and billing alerts.
- Choose one region and understand the cost drivers in [COST_AND_CLEANUP.md](COST_AND_CLEANUP.md).
- Confirm AWS CLI authentication with `aws sts get-caller-identity`; inspect the output privately and never commit it.

No AWS account currently available? Stop here. The repository remains fully useful for code reading, tests, CI, and interview practice.

## Module 7 — bootstrap remote state

The bootstrap stack intentionally begins with local state because the remote bucket does not exist yet:

```bash
terraform -chdir=bootstrap/state init
terraform -chdir=bootstrap/state plan -out=state.tfplan
terraform -chdir=bootstrap/state apply state.tfplan
terraform -chdir=bootstrap/state output state_bucket_name
```

Create an untracked backend file:

```bash
cp environments/learning/backend.hcl.example environments/learning/backend.hcl
```

Replace the bucket placeholder with the output. The root backend already enables encrypted S3 state and native S3 lockfiles. Do not add a DynamoDB lock table.

Checkpoint: the bucket has versioning, default encryption, ownership enforcement, and all public access blocked.

## Module 8 — connect GitHub Actions with OIDC

GitHub Actions uses short-lived identity tokens, not access-key secrets. Verify the repository's immutable numeric ID:

```bash
gh api repos/jeevanm84/terraform-aws-ha-web-platform --jq .id
```

The original repository ID is already the module default. Forks and copies must override it. Create `bootstrap/github-oidc/terraform.auto.tfvars` locally; this filename is ignored by Git:

```hcl
# Required only when using a fork or copied repository:
github_repository_id = "REPLACE_WITH_YOUR_NUMERIC_ID"
state_bucket_name    = "REPLACE_WITH_STATE_BUCKET"
create_oidc_provider = true
```

If the AWS account already has `token.actions.githubusercontent.com` configured, set `create_oidc_provider = false`.

Review and apply the bootstrap stack:

```bash
terraform -chdir=bootstrap/github-oidc init
terraform -chdir=bootstrap/github-oidc plan -out=oidc.tfplan
terraform -chdir=bootstrap/github-oidc apply oidc.tfplan
```

In GitHub repository settings, create environments named `aws-plan` and `aws-apply`:

- `aws-plan`: variable `AWS_REGION`; secrets `AWS_PLAN_ROLE_ARN` and `TF_STATE_BUCKET`.
- `aws-apply`: variable `AWS_REGION`; secrets `AWS_APPLY_ROLE_ARN` and `TF_STATE_BUCKET`; add required reviewers.

The role trust policies bind both the visible GitHub names and immutable owner/repository IDs. Renaming or transferring the repository requires updating the trust policies.

## Module 9 — plan, apply, and verify

1. Open **Actions → AWS Plan → Run workflow**.
2. Select `learning` first.
3. Read the complete plan: resource count, CIDRs, public ingress, NAT mode, database status, and tags.
4. Open **Actions → AWS Apply → Run workflow**.
5. Choose the same profile and type `APPLY` exactly.
6. Approve the protected `aws-apply` environment if prompted.

The workflow creates a saved plan and applies that exact file in the same job. When complete, obtain `application_url` from Terraform output in a trusted local session or add a non-sensitive summary step to your own workflow.

Verification checklist:

- The ALB spans two public subnets and reports two healthy targets.
- EC2 instances have no public IP addresses.
- The Auto Scaling group desired capacity is two.
- The `/health` path returns HTTP 200.
- CloudWatch displays healthy/unhealthy target and CPU metrics.
- If RDS is enabled, it is not publicly accessible and its password is managed by Secrets Manager.

## Module 10 — destroy and verify cleanup

For the HA profile, first change `database_deletion_protection` to `false`, plan/apply that change, and preserve any required final snapshot. Then:

1. Open **Actions → AWS Destroy → Run workflow**.
2. Select the profile that is actually deployed.
3. Type `DESTROY` exactly and approve the protected environment.
4. Review the destroy preview in the workflow log before the apply step proceeds.

After completion, verify in AWS that the load balancer, target group, Auto Scaling group, EC2 instances, NAT gateways/EIPs, RDS instance, SNS topic, and VPC are gone. The state bucket and GitHub IAM roles are separate bootstrap resources; retain them for future labs or remove them deliberately using the reverse bootstrap sequence in [COST_AND_CLEANUP.md](COST_AND_CLEANUP.md).

## Completion checklist

- [ ] I can explain why the root module and child modules are separated.
- [ ] I ran validation and mock tests without an AWS account.
- [ ] I understand the single-NAT cost/availability trade-off.
- [ ] I know why state and lockfiles need write permission during plan.
- [ ] I can explain GitHub OIDC and why access keys are not stored.
- [ ] If I deployed, I verified health and completed cleanup.
- [ ] I did not commit state, plans, credentials, backend values, or account data.

Next, use [INTERVIEW_QUESTIONS.md](INTERVIEW_QUESTIONS.md) to practice explaining—not merely running—the design.
