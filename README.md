# Multi-Cloud Terraform Module Registry 🌍📦

[![CI Pipeline](https://github.com/SumitDalavi/multi-cloud-terraform-modules/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/SumitDalavi/multi-cloud-terraform-modules/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/SumitDalavi/multi-cloud-terraform-modules?color=0969da&label=release&logo=github)](https://github.com/SumitDalavi/multi-cloud-terraform-modules/releases)
[![Release Workflow](https://github.com/SumitDalavi/multi-cloud-terraform-modules/actions/workflows/release.yml/badge.svg)](https://github.com/SumitDalavi/multi-cloud-terraform-modules/actions/workflows/release.yml)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io)
[![SBOM](https://img.shields.io/badge/SBOM-SPDX%202.3-blueviolet?logo=spdx)](https://github.com/SumitDalavi/multi-cloud-terraform-modules/releases/tag/v0.2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

> **Maturity:** Functional Prototype
> _Opinionated, secure-by-default Terraform modules for AWS and Azure — with Terratest coverage._

## The Problem

"I use Terraform" is the most common line on DevOps resumes. But writing `resource "aws_instance"` in a flat main.tf is fundamentally different from **authoring reusable, tested, opinionated modules** that encode security and compliance by default. Hiring managers know the difference.

## The Solution

A curated registry of robust Terraform modules covering the two most common cloud providers, with:

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

> **💡 Cost Estimation:** Consider integrating [Infracost](https://www.infracost.io/) into CI to show cost impact of infrastructure changes in PRs — pairs well with the [FinOps Cost Dashboard](https://github.com/SumitDalavi/finops-cost-dashboard) repo.

## Mock Boundaries (Honest Scope)

| What | Status | Details |
|---|---|---|
| Terraform Code | **Real** | HCL code is fully valid and runnable. |
| Terratest | **Real** | Go integration tests are fully implemented. |
| Cloud Environments | **Mocked** | CI execution simulates plans without requiring live AWS/Azure credentials. |

## 🛠️ Verification & Deployment Tiers

These reusable infrastructure modules support progressive adoption from local validation to live multi-cloud provisioning.

### Tier 1: Offline Linting & Static Validation (Default)
Validate module syntax, formatting, and security policies without cloud credentials.
- **Execution:** `terraform fmt -check`, `terraform validate`, `tflint`.
- **Behavior:** Validates HCL configuration and input/output contracts locally without initializing remote state.
- **Zero Cloud Footprint:** Zero AWS, Azure, or GCP credentials required.

### Tier 2: Terratest Integration Testing
Run automated end-to-end integration tests using isolated sandbox credentials.
- **Execution:** Supply credentials via `.env` or cloud CLI and run `go test -v ./tests/...`.
- **Behavior:** Dynamically provisions ephemeral resources, runs validation assertions, and destroys resources.

### Tier 3: Production Infrastructure Provisioning
Consume standardized modules across production workspaces and GitOps pipelines.
- **Distribution:** Tagged release tarballs with verified checksums and SPDX SBOM available on [GitHub Releases](https://github.com/SumitDalavi/multi-cloud-terraform-modules/releases).

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md) — System diagram and component details
- [Runbook](docs/runbook.md) — Setup, commands, and expected outputs
- [Decisions](docs/decisions.md) — ADRs for module design choices
- [Changelog](docs/changelog.md) — Change history

## Decision Log

| Decision | Rationale |
|----------|-----------|
| Separate AWS/Azure directories | Clear separation enables teams to adopt modules per-cloud without pulling in irrelevant providers |
| Terratest over `terraform test` | Terratest is the industry standard for module testing; Go test framework provides richer assertions |
| Encryption enabled by default | Meets SOC2/ISO27001 baseline without requiring consumers to configure it |
| Private networking by default | All databases and clusters default to private subnets; public access is opt-in |

## 📋 Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [Terraform](https://www.terraform.io/) | >= 1.5 | Infrastructure as Code |
| [Go](https://go.dev/) | >= 1.21 | Running Terratest |
| [AWS CLI](https://aws.amazon.com/cli/) | >= 2.x | AWS provider (optional) |
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) | >= 2.x | Azure provider (optional) |

## 🚀 Step-by-Step Setup

```bash
# 1. Clone the repository
git clone https://github.com/SumitDalavi/multi-cloud-terraform-modules.git
cd multi-cloud-terraform-modules

# 2. Initialize a module (e.g., AWS EKS)
cd modules/aws/eks
terraform init

# 3. Review the plan (requires AWS credentials)
terraform plan -var="cluster_name=my-eks" -var="region=us-west-2"
```

## 🧪 Usage & Demo

### Using a module in your own project
```hcl
# In your own Terraform project
module "eks_cluster" {
  source       = "github.com/SumitDalavi/multi-cloud-terraform-modules//modules/aws/eks"
  cluster_name = "production-eks"
  region       = "us-west-2"
  node_count   = 3
}

module "rds_database" {
  source          = "github.com/SumitDalavi/multi-cloud-terraform-modules//modules/aws/rds"
  instance_name   = "app-database"
  engine          = "postgres"
  master_password = var.db_password  # Always use variables, never hardcode
}
```

### Running Terratest integration tests
```bash
cd tests/
go test -v -timeout 30m ./...
```

### Validate all modules compile
```bash
# Quick validation of each module
for dir in modules/aws/eks modules/aws/rds modules/aws/s3 modules/azure/aks modules/azure/cosmosdb modules/azure/blob-storage; do
  echo "Validating $dir..."
  terraform -chdir=$dir init -backend=false
  terraform -chdir=$dir validate
done
```

## ✅ Verification

| Check | Command | Expected |
|-------|---------|----------|
| Module validates | `terraform validate` | Success |
| Plan runs | `terraform plan` | No errors |
| Tests pass | `go test -v ./...` | All tests pass |
| Modules documented | Check each module's `variables.tf` | Input vars documented |

## Module Documentation
### AWS S3 Module (`modules/aws/s3`)
An opinionated S3 module enforcing server-side encryption with KMS, blocking all public access, and enabling versioning by default.

**Inputs:**
- `bucket_name` (string, required): The name of the S3 bucket.
- `access_log_bucket` (string, optional): Target bucket for access logs.
- `tags` (map, optional): Additional resource tags.

**Outputs:**
- `bucket_id`: The ID of the created bucket.
- `bucket_arn`: The ARN of the created bucket.

## Terraform Plan Output (Fixture)
Example of `terraform plan` execution for the S3 module:
```text
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
  # aws_s3_bucket.this will be created
  + resource "aws_s3_bucket" "this" {
      + bucket                      = "test-terratest-bucket"
      + force_destroy               = false
      ...
    }
Plan: 4 to add, 0 to change, 0 to destroy.
```

## 🔒 Release & Security Verification

This repository is published as an immutable release catalog under the portfolio release standard:

- **Release Artifacts:** Authenticated distribution bundle (`multi-cloud-terraform-modules-v0.2.0.tar.gz`) containing production policies, modules, and manifests.
- **Cryptographic Integrity:** SHA-256 integrity hash provided in `checksums.txt`.
- **Software Bill of Materials (SBOM):** Fully compliant SPDX JSON SBOM (`sbom.spdx.json`) generated by Anchore Syft.

### Verification Commands
```bash
# 1. View Release Metadata
gh release view v0.2.0 --repo SumitDalavi/multi-cloud-terraform-modules

# 2. Download Release Assets & Verify SHA256 Checksum
gh release download v0.2.0 --repo SumitDalavi/multi-cloud-terraform-modules --pattern "*.tar.gz" --pattern "checksums.txt"
sha256sum -c checksums.txt

# 3. Inspect SPDX SBOM
gh release download v0.2.0 --repo SumitDalavi/multi-cloud-terraform-modules --pattern "sbom.spdx.json"
cat sbom.spdx.json | jq .spdxVersion
```

## 👨‍💻 Author

**Sumit Dalavi** — Senior DevSecOps / Platform Engineer
[GitHub](https://github.com/SumitDalavi) | [LinkedIn](https://in.linkedin.com/in/sumit-dalavi-762838129)

---
*Built with a focus on robust patterns, not toy demos.*
