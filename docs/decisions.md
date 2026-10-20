# Decisions

## ADR-001: Terratest for Module Validation
**Date:** 2026-08-29  
**Status:** Accepted

**Context:**  
Terraform modules can be validated syntactically using `terraform validate` or `tflint`. However, to ensure they actually spin up working infrastructure with the correct outputs and properties, we need integration testing.

**Decision:**  
We use Terratest (by Gruntwork) over HashiCorp's experimental `terraform test`.

**Consequences:**  
- ✅ We can write rich assertions in Go (e.g., hitting an HTTP endpoint after provisioning).
- ✅ Clean destroy hooks (even if tests panic).
- ⚠️ Adds Go as a dependency for the IaC repository.

## ADR-002: Multi-Tier Verification & OCI Dual Distribution
- **Context:** Declarative infrastructure and policy catalogs required robust local simulation gates without imposing cloud provider dependencies or credentials during CI/CD.
- **Decision:** Establish a strict 3-tier verification model (offline linting → sandbox cluster test → GitOps deployment) and distribute validated release packages with SBOMs and OCI container/chart registries.
- **Consequences:** 
  - *Pros:* Zero cloud credentials required for CI validation; verifiable supply-chain integrity via Syft SBOMs.
  - *Cons:* Requires maintaining local test fixtures and mock plan inputs.
