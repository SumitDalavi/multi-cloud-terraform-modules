# Runbook — multi-cloud-terraform-modules
> Last updated: 2026-08-29

## Prerequisites
| Tool | Required Version | How to check |
|---|---|---|
| Terraform | >= 1.5 | `terraform -v` |
| Go | >= 1.21 | `go version` |

## Quick Start
```bash
# Validate all modules
for dir in modules/aws/* modules/azure/*; do
  terraform -chdir=$dir init -backend=false
  terraform -chdir=$dir validate
done
```

## Run Tests
```bash
# Note: Real terratest execution requires AWS/Azure credentials
# go test -v -timeout 30m ./...

# CI Ephemeral Plan Test
bash tests/e2e/test_ephemeral_plan.sh
```

Expected output:
```
✅ [Simulated] Ephemeral Plan for AWS EKS generated.
```

## Environment Variables
| Variable | Default | Purpose |
|---|---|---|
| AWS_ACCESS_KEY_ID | - | Required for AWS tests |
| AWS_SECRET_ACCESS_KEY | - | Required for AWS tests |
| ARM_CLIENT_ID | - | Required for Azure tests |

## Common Failure Modes
| Symptom | Cause | Fix |
|---|---|---|
| Plan hangs | Missing credentials | Ensure AWS/Azure ENV vars are set |
