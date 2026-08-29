# Changelog

## [Unreleased] - 2026-08-30

### Added/Fixed (Phase 6 Functional Upgrades)
- Fixed GitHub Actions CI branch trigger (`main` to `master`).
- Updated module validation loop to recursively discover nested modules (e.g., `aws/eks`, `aws/s3`).
- Fixed Terratest integration by ensuring Go test packages match and removing deprecated Terraform `-var` arguments for syntax validation.
- Added `s3-plan-output.txt` fixture as a reference Terraform plan.
- Added GitHub Actions CI status badge.

## [2026-08-29] — Phase 2 Evidence
### Added
- Added `tests/e2e/test_ephemeral_plan.sh` simulating Terraform plan execution in ephemeral CI environments.
- Standardized documentation (`runbook.md`, `decisions.md`, `ARCHITECTURE.md`).
- Added maturity badge and mock boundaries to `README.md`.
