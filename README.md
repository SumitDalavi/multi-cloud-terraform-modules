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

> **💡 Cost Estimation:** Consider integrating [Infracost](https://www.infracost.io/) into CI to show cost impact of infrastructure changes in PRs — pairs well with the [FinOps Cost Dashboard](https://github.com/SumitDalavi/finops-cost-dashboard) repo.

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

## 👨‍💻 Author

**Sumit Dalavi** — Senior DevSecOps / Platform Engineer
[GitHub](https://github.com/SumitDalavi) | [LinkedIn](https://in.linkedin.com/in/sumit-dalavi-762838129)

---

*Built with a focus on production-grade patterns, not toy demos.*

## CI & Reliability Updates (August 2026)

- **CI Pipeline Remediation:** Successfully resolved all CI/CD pipeline failures and established baseline CI workflows.
- **Specific Fix:** Added and configured robust GitHub Actions workflows for automated testing, linting, and formatting.
- **Status:** 🟩 Passing
