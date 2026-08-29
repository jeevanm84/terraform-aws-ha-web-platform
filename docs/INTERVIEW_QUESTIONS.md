# Interview practice

Use the repository to support an explanation, not as a script to memorize. For each answer, state the requirement, design choice, trade-off, failure mode, and verification method.

## Beginner

1. What is the difference between a provider, resource, data source, variable, local, and output?
2. Why does `terraform init -backend=false` work without an AWS account here?
3. What do `terraform fmt`, `validate`, `plan`, and `apply` each prove?
4. Why are `.terraform`, state, plan, backend, and auto-variable files ignored?
5. How does Terraform infer dependencies between the five modules?
6. Why are web instances in private rather than public subnets?

## Intermediate

1. Trace a browser request through the ALB to an instance and explain every security-group boundary.
2. Why does the default Auto Scaling group use two instances rather than one?
3. Compare `single` and `per_az` NAT modes for cost, cross-AZ dependence, and failure impact.
4. Why are database subnets isolated even though RDS security groups already restrict traffic?
5. How does `manage_master_user_password` improve secret handling, and what must an application still implement?
6. Why does an S3 lockfile require write/delete permissions during `terraform plan`?
7. How do mock-provider tests add value, and what can they not prove?

## Advanced

1. Explain the trust relationship among a GitHub environment, an OIDC subject, AWS STS, and an IAM role.
2. Why use separate plan/apply roles, and where is the current example still broader than ideal?
3. Why apply a saved plan rather than run a new implicit plan at approval time?
4. Design a multi-account promotion flow for dev, staging, and production without copying state.
5. How would you add WAF, HTTPS/DNS, VPC endpoints, centralized logs, policy-as-code, and drift detection?
6. Define realistic RTO/RPO targets and show how you would test RDS restore and regional recovery.
7. What state migration steps are needed to split one environment into several independently owned stacks?
8. How would you prove that the platform survives instance, AZ, NAT, and database failures?

## Scenario drill

You receive a plan that replaces the ALB, changes `allowed_ipv4_cidrs` to the whole internet, increases NAT gateways, and enables Multi-AZ RDS. Explain:

- which changes affect availability;
- which affect exposure and security;
- which affect monthly cost;
- whether downtime is expected;
- what evidence you need before approval;
- how you would roll back safely.

## Strong project explanation

A concise explanation should cover:

1. **Problem:** teach an end-to-end Terraform deployment without requiring cloud access for initial learning.
2. **Architecture:** two-AZ ALB/ASG platform with private compute, isolated optional RDS, and observability.
3. **Safety:** no SSH, managed secrets, encrypted storage/state, OIDC, protected manual workflows, and cleanup guidance.
4. **Testing:** format/validate plus mocked cost-aware and resilience plans in CI.
5. **Trade-offs:** single NAT and disabled RDS reduce default cost; the HA profile increases resilience and cost.
6. **Next step:** organization-specific production controls and recovery testing.
