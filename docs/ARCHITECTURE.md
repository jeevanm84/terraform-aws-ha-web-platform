# Architecture

## System view

```mermaid
flowchart TB
  subgraph GitHub
    PR[Pull request] --> CI[Offline CI<br/>fmt · validate · mock tests]
    Manual[Manual workflow] --> OIDC[GitHub OIDC token]
  end

  subgraph AWS[One AWS Region]
    OIDC --> Roles[Plan role / Apply role]
    Roles --> State[(Versioned S3 state<br/>native lockfile)]

    subgraph VPC[10.42.0.0/16 · two Availability Zones]
      Internet((Internet)) --> ALB[Public ALB]
      ALB --> WebA[Web instance · AZ A]
      ALB --> WebB[Web instance · AZ B]
      WebA -. controlled egress .-> NAT[NAT gateway profile]
      WebB -. controlled egress .-> NAT
      WebA -. optional MySQL .-> DB[(RDS)]
      WebB -. optional MySQL .-> DB
    end

    ALB --> Metrics[CloudWatch + SNS]
    WebA --> Metrics
    WebB --> Metrics
  end
```

## Network tiers

| Tier | Resources | Internet route | Inbound rule |
|---|---|---|---|
| Public | ALB, NAT gateway/EIP | Internet gateway | Configured public CIDRs to 80/443 |
| Private compute | Auto Scaling instances | NAT for outbound only | Application port from ALB security group |
| Isolated database | Optional RDS | None | MySQL from compute security group |

Security groups reference other security groups where possible, so changing instance addresses does not require rule changes. No instance exposes SSH. Systems Manager provides authenticated, audited administration through the EC2 role.

## Availability profiles

| Concern | Learning profile | Resilience profile |
|---|---|---|
| ALB | Two AZs | Two AZs |
| Web capacity | Minimum two | Minimum two |
| NAT | One shared gateway | One gateway per AZ |
| RDS | Disabled | Optional Multi-AZ |
| Cost | Lower | Higher |

A single NAT gateway is a cost optimization, not a fully highly available egress design. The application can continue serving existing traffic if an instance fails, but private instances in the other AZ can lose outbound package/service access if the single NAT path is unavailable.

## State and deployment trust

```mermaid
sequenceDiagram
  actor Maintainer
  participant GH as GitHub protected environment
  participant AWS as AWS STS
  participant S3 as S3 state + lockfile
  participant TF as Terraform

  Maintainer->>GH: Start manual plan/apply
  GH->>AWS: Exchange signed OIDC token
  AWS-->>GH: Short-lived role credentials
  GH->>S3: Acquire .tflock and read state
  GH->>TF: Create saved plan
  Maintainer->>GH: Environment approval
  GH->>TF: Apply exact saved plan
  TF->>S3: Write state and release lock
```

The plan and apply roles trust different GitHub environment subjects. The subject includes immutable owner and repository IDs as well as names. State access is limited to this repository's key prefix.

## Production gaps to evaluate

The repository demonstrates sound patterns but cannot know an organization's requirements. Production evaluation should cover Route 53 and ACM lifecycle, AWS WAF, customer-managed KMS keys, VPC endpoints, centralized logs, secrets rotation consumers, database parameter groups, restore tests, scaling policies, load tests, organization policy, drift detection, separate accounts, and tested recovery objectives.
