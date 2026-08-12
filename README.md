# Multi-Cloud Terraform Module Registry 🌍📦

> Opinionated, secure-by-default Terraform modules for AWS and Azure — with Terratest coverage — proving IaC ownership at the module-authoring level.

## The Problem

"I use Terraform" is the most common line on DevOps resumes. But writing `resource "aws_instance"` in a flat main.tf is fundamentally different from **authoring reusable, tested, opinionated modules** that encode security and compliance by default. Hiring managers know the difference.

## The Solution

A curated registry of production-grade Terraform modules covering the two most common cloud providers, with:

| Module | AWS | Azure |
|--------|-----|-------|
| Kubernetes Cluster | EKS | AKS |
| Managed Database | RDS (PostgreSQL) | Cosmos DB |
| Object Storage | S3 | Blob Storage |

Every module is:
- **Secure by default**: Encryption at rest, private networking, least-privilege IAM
- **Opinionated**: Sane defaults that match what SRE teams actually deploy
- **Tested**: Terratest integration tests that validate the module compiles and plans correctly

## Why This Over the Obvious Alternative

Public Terraform registries (`registry.terraform.io`) exist — but they're generic. Enterprise platform teams build **internal module registries** with guardrails baked in. This repo demonstrates that exact pattern: modules that developers consume without needing to understand VPC peering, encryption keys, or IAM policies.

## 📁 Project Structure

```
├── modules/
│   ├── aws/
│   │   ├── eks/           # EKS cluster with managed node groups
│   │   ├── rds/           # RDS PostgreSQL with encryption + private subnets
│   │   └── s3/            # S3 bucket with encryption, versioning, access logging
│   └── azure/
│       ├── aks/           # AKS cluster with system + user node pools
│       ├── cosmosdb/      # Cosmos DB with automatic failover
│       └── blob-storage/  # Blob Storage with soft delete + encryption
├── tests/
│   └── modules_test.go    # Terratest integration tests
├── examples/
│   └── complete/          # Full usage example consuming multiple modules
├── docs/ARCHITECTURE.md
└── README.md
```

## Decision Log

| Decision | Rationale |
|----------|-----------|
| Separate AWS/Azure directories | Clear separation enables teams to adopt modules per-cloud without pulling in irrelevant providers |
| Terratest over `terraform test` | Terratest is the industry standard for module testing; Go test framework provides richer assertions |
| Encryption enabled by default | Meets SOC2/ISO27001 baseline without requiring consumers to configure it |
| Private networking by default | All databases and clusters default to private subnets; public access is opt-in |

## 👨‍💻 Author

*Built to demonstrate Terraform module authorship at the platform-engineering level, not just Terraform consumption.*
