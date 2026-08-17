# Architecture: Multi-Cloud Terraform Module Registry

## System Diagram
The following Mermaid.js sequence diagram maps the core workflow and interactions:

```mermaid
sequenceDiagram
    Dev->>Module: Source module
Module->>AWS: Provision VPC
Module->>Azure: Provision VNet
```


## Design Philosophy
Every module follows three principles: **secure by default**, **opinionated defaults**, and **testable**.

### Secure by Default
- All storage modules enable encryption at rest (KMS for AWS, platform-managed for Azure)
- All database modules disable public access
- All S3/Blob modules block public ACLs
- All Kubernetes clusters use private API endpoints by default

### Opinionated Defaults
Rather than exposing every possible variable, modules ship with sane defaults that match what SRE teams actually deploy. Consumers can override, but the "happy path" is already secure and production-ready.

### Tested
Terratest validates that every module:
1. Initializes correctly (`terraform init`)
2. Validates syntax (`terraform validate`)
3. Plans without errors against the given variables

## Module Comparison: AWS vs Azure

| Capability | AWS Module | Azure Module |
|------------|-----------|-------------|
| Kubernetes | EKS + Managed Node Groups | AKS + System/User Node Pools |
| Database | RDS PostgreSQL (Multi-AZ) | Cosmos DB (Geo-Replicated) |
| Storage | S3 (KMS, Versioning, Logging) | Blob (Soft Delete, Versioning, TLS 1.2) |
