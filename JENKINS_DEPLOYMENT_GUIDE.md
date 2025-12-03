# Jenkins Deployment Guide for Media Compressor

## Overview
This guide walks through deploying the Media Compressor project using Jenkins CI/CD pipeline.

---

## Prerequisites

### 1. **Jenkins Server Setup**
```bash
# Install Jenkins (if not already installed)
# On Ubuntu/Debian:
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

# On CentOS/RHEL:
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins
```

### 2. **Required Jenkins Plugins**
Install these plugins in Jenkins:
- Pipeline
- Git
- Docker
- Kubernetes
- AWS credentials
- SonarQube Scanner
- Ansible
- Blue Ocean (optional, for better UI)

**Installation Steps:**
1. Go to Manage Jenkins → Plugin Manager
2. Search for each plugin
3. Click "Install without restart"

### 3. **System Requirements**
- **Jenkins Server**: Minimum 4GB RAM, 20GB disk space
- **Docker**: Installed and running
- **kubectl**: Configured for EKS cluster access
- **Ansible**: Version 2.9+
- **AWS CLI**: Configured with appropriate credentials
- **SonarQube**: Running (optional, for code quality)

---

## Step-by-Step Jenkins Deployment

### Step 1: Create Jenkins Credentials

#### 1.1 AWS Credentials
```
1. Go to Manage Jenkins → Manage Credentials
2. Click "Add Credentials"
3. Select "AWS Credentials"
4. Enter:
   - Access Key ID: <your-aws-access-key>
   - Secret Access Key: <your-aws-secret-key>
   - ID: aws-credentials
5. Click "Create"
```

#### 1.2 Docker Hub Credentials
```
1. Go to Manage Jenkins → Manage Credentials
2. Click "Add Credentials"
3. Select "Username with password"
4. Enter:
   - Username: <dockerhub-username>
   - Password: <dockerhub-password>
   - ID: dockerhub-credentials
5. Click "Create"
```

#### 1.3 Kubeconfig Credentials
```
1. Go to Manage Jenkins → Manage Credentials
2. Click "Add Credentials"
3. Select "Secret file"
4. Upload your kubeconfig file
5. Set ID: kubeconfig-media-compressor
6. Click "Create"
```

#### 1.4 SonarQube Token (Optional)
```
1. Get token from SonarQube: http://sonarqube:9000/account/security/
2. Go to Manage Jenkins → Manage Credentials
3. Click "Add Credentials"
4. Select "Secret text"
5. Enter token in "Secret" field
6. Set ID: sonarqube-token
7. Click "Create"
```

### Step 2: Create New Jenkins Pipeline Job

```
1. Click "New Item"
2. Enter job name: "media-compressor-deployment"
3. Select "Pipeline"
4. Click "OK"
```

### Step 3: Configure Pipeline

#### 3.1 Pipeline Configuration
```
1. Go to Pipeline section
2. Select "Pipeline script from SCM"
3. Configure SCM:
   - Repository URL: https://github.com/SaikiranAsamwar/Media-Compressor-Devops.git
   - Branch: */main
   - Script Path: jenkins/Jenkinsfile
```

#### 3.2 Build Triggers
```
1. Check "GitHub hook trigger for GITScm polling"
   (This enables automatic builds on git push)
```

#### 3.3 Advanced Settings
```
1. Pipeline Speed/Durability: "Performance optimized"
2. Timeout: Set to 30 minutes
3. Keep builds: Last 10 builds
```

### Step 4: Configure GitHub Webhook (Optional but Recommended)

#### 4.1 In GitHub Repository
```
1. Go to Settings → Webhooks
2. Click "Add webhook"
3. Payload URL: http://<jenkins-server>/github-webhook/
4. Content type: application/json
5. Events: Push events, Pull requests
6. Active: ✓ Check
7. Click "Add webhook"
```

#### 4.2 Verify Webhook Connection
```
1. Go back to Webhooks
2. Click the webhook
3. Look for "Recent Deliveries"
4. Should show green checkmarks
```

---

## Pipeline Stages Explained

### Stage 1: Checkout & Prepare
**What it does:**
- Clones the latest code from GitHub
- Generates unique image tags with build number and commit ID
- Prepares environment variables

**Example output:**
```
Starting deployment pipeline for Media Compressor
Image tag: v42-abc1234
```

### Stage 2: Code Quality & Security (Parallel)
**SonarQube Analysis:**
- Analyzes code quality
- Reports security vulnerabilities
- Provides code coverage metrics

**Security Scan:**
- Runs npm audit on dependencies
- Checks for hardcoded secrets
- Identifies security issues

**Dependency Check:**
- Identifies outdated packages
- Checks for vulnerable versions

### Stage 3: Build & Test (Parallel)
**Backend Build & Test:**
- Installs npm dependencies
- Runs unit tests
- Generates test reports

**Frontend Build & Test:**
- Validates HTML/CSS/JavaScript files
- Checks for syntax errors

### Stage 4: Docker Build & Push (Parallel)
**Backend Image:**
- Builds Docker image from backend/Dockerfile
- Scans for vulnerabilities using Trivy
- Pushes to ECR registry

**Frontend Image:**
- Builds Docker image from frontend/Dockerfile
- Scans for vulnerabilities
- Pushes to ECR registry

### Stage 5: Deploy with Ansible
**What it does:**
- Updates kubeconfig for EKS cluster access
- Installs required Ansible collections
- Runs deployment playbook
- Deploys backend and frontend to Kubernetes

### Stage 6: Health Checks & Integration Tests
**Performs:**
- API endpoint health checks
- Verifies service connectivity
- Runs smoke tests
- Validates deployment

---

## Deployment Variables Configuration

Edit `jenkins/Jenkinsfile` environment variables:

```groovy
environment {
    AWS_REGION = 'us-west-2'              # Your AWS region
    AWS_ACCOUNT_ID = '514439471441'       # Your AWS account ID
    ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    IMAGE_PREFIX = 'saikiranasamwar4'     # Your Docker registry prefix
    CLUSTER_NAME = 'media-compressor-cluster'  # Your EKS cluster name
    KUBECONFIG = credentials('kubeconfig-media-compressor')  # Stored credentials ID
}
```

---

## Manual Deployment Steps (Without Jenkins)

If you want to run the pipeline manually:

### 1. Prerequisites
```bash
aws configure
export AWS_REGION=us-west-2
export AWS_ACCOUNT_ID=514439471441
export CLUSTER_NAME=media-compressor-cluster
```

### 2. Build Docker Images
```bash
# Backend
docker build -t saikiranasamwar4/media-compressor-backend:v1 ./backend
docker push <ecr-registry>/saikiranasamwar4/media-compressor-backend:v1

# Frontend
docker build -t saikiranasamwar4/media-compressor-frontend:v1 ./frontend
docker push <ecr-registry>/saikiranasamwar4/media-compressor-frontend:v1
```

### 3. Deploy to Kubernetes
```bash
# Update kubeconfig
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

# Deploy using Ansible
cd ansible
ansible-playbook -i inventory site.yml
```

### 4. Verify Deployment
```bash
kubectl get pods -n media-compressor
kubectl get services -n media-compressor
kubectl logs -n media-compressor deployment/media-compressor-backend
```

---

## Monitoring & Verification

### 1. Jenkins Dashboard
```
URL: http://<jenkins-server>:8080
View:
- Build history
- Log output
- Build status
- Stage duration
```

### 2. Kubernetes Verification
```bash
# Check deployments
kubectl get deployments -n media-compressor

# Check services
kubectl get services -n media-compressor

# Check pods
kubectl get pods -n media-compressor

# View logs
kubectl logs -f deployment/media-compressor-backend -n media-compressor
```

### 3. Application Health
```bash
# Check backend health
curl http://<load-balancer-ip>/api/health

# Check frontend
curl http://<load-balancer-ip>/

# View metrics
curl http://<load-balancer-ip>/metrics
```

---

## Troubleshooting Common Issues

### Issue 1: Docker Login Fails
**Solution:**
```bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <ecr-registry>
```

### Issue 2: Ansible Playbook Fails
**Solution:**
```bash
# Install required collections
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.general

# Run with verbose output
ansible-playbook -i inventory site.yml -vvv
```

### Issue 3: Kubernetes Deployment Fails
**Solution:**
```bash
# Check kubeconfig
kubectl config current-context

# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name media-compressor-cluster
```

### Issue 4: Image Push Fails
**Solution:**
```bash
# Check ECR repository exists
aws ecr describe-repositories --region us-west-2

# Create if missing
aws ecr create-repository --repository-name saikiranasamwar4/media-compressor-backend --region us-west-2
```

---

## Rollback Procedures

### Rollback to Previous Image Version
```bash
# Get previous image version
kubectl set image deployment/media-compressor-backend \
  backend=<ecr-registry>/saikiranasamwar4/media-compressor-backend:v<previous-tag> \
  -n media-compressor

# Verify rollback
kubectl get deployment media-compressor-backend -n media-compressor -o yaml
```

### Rollback via Kubectl
```bash
# View rollout history
kubectl rollout history deployment/media-compressor-backend -n media-compressor

# Rollback to previous revision
kubectl rollout undo deployment/media-compressor-backend -n media-compressor
```

---

## Jenkins Pipeline Workflow Diagram

```
START
  ↓
[Checkout & Prepare]
  ↓
[Code Quality & Security] ← Parallel: SonarQube, Security Scan, Dependency Check
  ↓
[Build & Test] ← Parallel: Backend Build, Frontend Build
  ↓
[Docker Build & Push] ← Parallel: Backend Image, Frontend Image
  ↓
[Deploy with Ansible]
  ↓
[Health Checks & Integration Tests]
  ↓
SUCCESS
```

---

## Best Practices

1. **Always test in staging first** before deploying to production
2. **Use meaningful image tags** (not just 'latest')
3. **Monitor logs** for errors during deployment
4. **Keep secrets in Jenkins credentials**, not in code
5. **Implement rollback procedures** before deployment
6. **Use health checks** to verify deployment success
7. **Set up notifications** for build failures
8. **Maintain kubeconfig** backup and access control

---

## Contact & Support

For issues or questions:
1. Check Jenkinsfile logs
2. Review Kubernetes pod logs
3. Verify AWS credentials and permissions
4. Check network connectivity to EKS cluster

---

**Jenkins Pipeline is now ready for deployment!** 🚀
