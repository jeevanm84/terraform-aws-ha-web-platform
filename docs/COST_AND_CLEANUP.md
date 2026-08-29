# Cost and cleanup

## Cost model

Running offline checks costs nothing. A real deployment can incur charges immediately. Prices vary by region and change over time, so use the AWS Pricing Calculator and service pricing pages before applying.

Primary cost drivers:

| Resource | Created by default cloud profile | Why it matters |
|---|---:|---|
| Application Load Balancer | Yes | Hourly and usage-based capacity charges |
| Two EC2 instances | Yes | Two instances are required for compute redundancy |
| NAT gateway | One | Hourly and per-GB processing; often the largest small-lab surprise |
| Elastic IP | With each NAT | Charges can apply depending on allocation/use |
| RDS | No | Instance, storage, backups; Multi-AZ materially increases cost |
| CloudWatch/SNS | Yes | Usually smaller, but alarms, metrics, logs, and notifications can charge |
| S3 state bucket | Bootstrap only | Normally small; versions accumulate over time |

The `ha` profile creates two NAT gateways and enables RDS/Multi-AZ. It is not a low-cost starter profile.

## Before applying

1. Use a dedicated sandbox account, not production.
2. Create an AWS Budget and alert thresholds.
3. Run the `learning` plan first and inspect every resource.
4. Keep RDS disabled until the networking and compute lessons are complete.
5. Schedule the destroy step; do not rely on memory.

## Workload cleanup

Use the manual **AWS Destroy** workflow with the same profile that was deployed. If database deletion protection is enabled, first set it to false and apply that change. Preserve a final snapshot when data matters.

Verify these categories are gone:

- ALB, listeners, and target group
- Auto Scaling group, launch template, and EC2 instances
- NAT gateways and Elastic IP allocations
- Optional RDS instance, subnet group, and managed credential secret
- CloudWatch alarms/dashboard and SNS topic/subscription
- VPC, internet gateway, route tables, subnets, and security groups

## Bootstrap cleanup

Bootstrap resources have separate state and are intentionally not removed with the workload.

1. Remove the GitHub environments or their secrets so workflows cannot target old roles.
2. Run `terraform -chdir=bootstrap/github-oidc destroy` with its original variables.
3. Preserve or export any state history required for audit/recovery.
4. Empty versioned objects and delete the S3 state stack only when no Terraform environment uses it. Set `force_destroy = true` only for this deliberate final operation.
5. If the GitHub OIDC provider is shared by other repositories, do not delete it; use `create_oidc_provider = false` in this stack and manage the shared provider separately.

Never delete a state bucket first and assume the AWS resources are gone. Losing state makes safe cleanup and ownership tracking harder.
