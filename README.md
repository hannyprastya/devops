# DevOps Infrastructure

This repository demonstrates enterprise-grade infrastructure automation, GitOps workflows, and cloud-native application deployment using industry-standard tools and best practices.

## Design

### Cloud & Infrastructure
- **AWS Cloud Architecture**: Multi-service setup with CloudFront, S3, Route53, ACM, CloudWatch
- **Infrastructure as Code**: OpenTofu/Terraform for declarative infrastructure management
- **Remote State Management**: S3-backed state with built-in locking
- **DNS & CDN**: Global content delivery with custom domain and SSL/TLS
- **Monitoring & Observability**: CloudWatch dashboards, alarms, and SNS notifications

### DevOps & GitOps
- **GitOps with FluxCD**: Automated Kubernetes deployments via Git reconciliation
- **CI/CD Automation**: GitHub Actions workflows with OIDC authentication
- **Containerization**: Docker-based application packaging and deployment
- **Secret Management**: External Secrets Operator with HashiCorp Vault integration
- **High Availability**: Auto-scaling, health checks, and multi-replica deployments

### Kubernetes & Container Orchestration
- **Kubernetes Manifests**: Production-ready deployments, services, and ingress
- **Kustomize**: Base/overlay pattern for multi-environment configuration
- **Horizontal Pod Autoscaling**: CPU/memory-based auto-scaling policies
- **Ingress & TLS**: HAProxy ingress with Let's Encrypt certificates
- **StatefulSets**: Redis deployment with persistent volumes

### Security & Best Practices
- **Zero-Trust Security**: OIDC authentication, no long-lived credentials
- **Secret Management**: Vault-backed secrets, encryption at rest
- **Network Security**: HTTPS-only, security headers, CSP policies
- **Least Privilege**: IAM roles with minimal required permissions
- **Compliance**: CAA records, DNSSEC support, automated certificate rotation

## 📁 Project Structure

```
devops/
├── tofu/               # OpenTofu/Terraform infrastructure (AWS)
├── flux/               # FluxCD GitOps manifests (Kubernetes)
└── .github/

```

## Architecture Overview

### AWS Static Website Infrastructure
```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│  Route53    │─────▶│  CloudFront  │─────▶│  S3 Bucket  │
│  (DNS)      │      │  (Global CDN)│      │  (Storage)  │
└─────────────┘      └──────────────┘      └─────────────┘
                            │
                            ├─ CloudFront Functions
                            ├─ Security Headers
                            └─ ACM Certificate
```

### Kubernetes GitOps Workflow
```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│   Git Repo   │─────▶│   FluxCD     │─────▶│  Kubernetes  │
│   (Source)   │      │ (Controller) │      │   Cluster    │
└──────────────┘      └──────────────┘      └──────────────┘
                            │
                            ├─ Auto-reconciliation (1m)
                            ├─ Kustomize overlays
                            └─ Health checks
```

## Features

### Infrastructure Management
- **Automated Deployments**: Push-to-deploy via GitHub Actions
- **Plan Review**: Automated plan comments on pull requests
- **State Management**: Centralized S3 backend with locking
- **Cost Optimization**: Lifecycle policies, appropriate instance sizing

### Application Deployment
- **GitOps Workflow**: Declarative, Git-based deployments
- **Auto-scaling**: HPA with CPU/memory metrics
- **Zero-downtime**: Rolling updates with readiness/liveness probes
- **Secret Rotation**: Automatic sync from Vault every 1 minute

### Observability
- **CloudWatch Metrics**: Request volume, error rates, cache hits
- **Custom Dashboards**: Real-time infrastructure visualization
- **Email Alerts**: SNS notifications for critical events
- **Access Logs**: CloudFront logs stored in S3

## 🔧 Technologies Used

| Category | Technologies |
|----------|-------------|
| **IaC** | OpenTofu, Terraform, Kustomize |
| **Cloud** | AWS (S3, CloudFront, Route53, ACM, CloudWatch) |
| **GitOps** | FluxCD, Git |
| **Orchestration** | Kubernetes, Docker |
| **CI/CD** | GitHub Actions |
| **Security** | HashiCorp Vault, External Secrets Operator, OIDC |
| **Ingress** | HAProxy Ingress Controller, cert-manager |
| **Monitoring** | CloudWatch, Prometheus-compatible metrics |

## 🔐 Security Highlights

- **OIDC Authentication**: No long-lived AWS credentials in CI/CD
- **Secrets Management**: Vault-backed external secrets
- **Encryption**: At-rest (S3/AES256) and in-transit (TLS 1.2+)
- **Network Policies**: Ingress-based access control
- **Security Headers**: HSTS, CSP, X-Frame-Options, etc.
- **Least Privilege**: Minimal IAM and RBAC permissions
