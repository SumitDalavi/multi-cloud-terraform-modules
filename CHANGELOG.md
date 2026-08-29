# Changelog

All notable changes to the `multi-cloud-terraform-modules` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-08-30

### Added/Fixed (Phase 6 Functional Upgrades)
- Fixed GitHub Actions CI branch trigger (`main` to `master`).
- Updated module validation loop to recursively discover nested modules (e.g., `aws/eks`, `aws/s3`).
- Fixed Terratest integration by ensuring Go test packages match and removing deprecated Terraform `-var` arguments for syntax validation.
- Added `s3-plan-output.txt` fixture as a reference Terraform plan.
- Added GitHub Actions CI status badge.
