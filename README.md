# project
# 🚀 Simple API – CI/CD with GitHub Actions, ECR & EKS

This project demonstrates a complete CI/CD pipeline for a Node.js application using **GitHub Actions**, **Amazon ECR**, and **Amazon EKS**, following DevOps best practices.

---

## 📐 Architecture Diagram

```
Developer → GitHub Repo
              │
              ▼
      GitHub Actions (CI/CD)
              │
     ┌────────┴────────┐
     │                 │
 Build & Test       Push Image
     │                 │
     ▼                 ▼
 Docker Image → Amazon ECR (Private Registry)
                              │
                              ▼
                     Amazon EKS Cluster or minikube or kind 
                              │
                              ▼
                    Kubernetes Deployment
                              │
                              ▼
                         Application Pods
                              │
                              ▼
                           Kubernetes Service
```

---

## CI/CD Workflow Explanation

The CI/CD pipeline is implemented using **GitHub Actions** and consists of three main jobs:

### Build & Test

* Triggered on every push to the `main` branch.
* Installs dependencies using `npm ci`.
* Runs unit tests using `npm test`.

### Build & Push Image

* Uses AWS OIDC authentication (no static AWS keys).
* Logs into Amazon ECR.
* Builds Docker image.
* Tags and pushes image to:

  ```
  869935107555.dkr.ecr.us-east-1.amazonaws.com/simple-api:latest
  ```

### Deploy to EKS

* Updates kubeconfig using AWS CLI.
* Applies Kubernetes manifests from the `k8s/` directory.
* Performs rolling updates to avoid downtime.

---

##Deployment Steps

### Prerequisites

* AWS account with ECR and EKS set up
* GitHub repository with OIDC IAM roles configured
* Docker, kubectl, and AWS CLI installed locally

### Steps

Clone the repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

 Ensure Kubernetes manifests exist

* `k8s/deployment.yaml`
* `k8s/service.yaml`

Push code to GitHub

```bash
git add .
git commit -m "Initial CI/CD setup"
git push origin main
```

GitHub Actions will automatically:

* Run tests
* Build and push Docker image to ECR
* Deploy to EKS

Verify deployment

```bash
kubectl get pods
kubectl get svc
```

Access the application

* Using NodePort:

  ```
  http://<NODE_IP>:<NODE_PORT>
  ```
* Or via port-forward:

  ```bash
  kubectl port-forward deployment/simple-api 3000:3000
  ```

  Then open: `http://localhost:3000`

---

## Monitoring & Alert Design

### Monitoring Tools

* **Amazon CloudWatch** for:

  * Container CPU & memory usage
  * Pod and node health
  * Application logs

* **Kubernetes Metrics Server** for:

  * Resource utilization
  * Horizontal Pod Autoscaling (HPA)

* (Optional) **Prometheus + Grafana** for advanced metrics and dashboards.

### Alerts

* CloudWatch alarms for:

  * High CPU/memory usage
  * Pod restarts
  * Node failures

* Alert notifications via:

  * Amazon SNS
  * Slack / Email integrations

---



### Identity & Access

* GitHub Actions uses **OIDC IAM roles** instead of static AWS keys.
* Separate IAM roles for:

  * ECR access
  * EKS access

### Image Security

* Use private ECR repositories.
* Enable image scanning in ECR.
* Use minimal base images (e.g., `node:20-alpine`).

###  Kubernetes Security

* Use dedicated **Service Accounts** per application.
* Apply **RBAC** policies with least privilege.
* Enforce **resource limits** to prevent resource abuse.

### Network Security

* Use **security groups** and **network policies** to restrict traffic.
* Expose services only when necessary.

### Code Security

* Add dependency scanning (e.g., Dependabot, Snyk).
* Run tests and linting in CI pipeline.

---

## ✅ Summary

This project provides a complete, production-ready CI/CD pipeline with:

* Automated testing
* Secure container builds
* Image storage in ECR
* Zero-downtime deployments to EKS
* Monitoring, alerting, and security best practices

---

👨‍💻 Created by Pratik
