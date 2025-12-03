# Jenkins Deployment - Quick Reference

## 🚀 QUICK START (7 Easy Steps)

### Step 1: Install & Setup Jenkins
```bash
# Install Jenkins (Ubuntu/Debian)
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update && sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### Step 2: Install Required Plugins
```
Jenkins Dashboard → Manage Jenkins → Plugin Manager
Install:
- Pipeline
- Git
- Docker
- Kubernetes
- AWS Credentials
- Ansible
```

### Step 3: Add AWS Credentials
```
Manage Jenkins → Manage Credentials → Add
- Type: AWS Credentials
- Access Key & Secret Key
- ID: aws-credentials
```

### Step 4: Add Docker Credentials
```
Manage Jenkins → Manage Credentials → Add
- Type: Username with Password
- DockerHub Username & Password
- ID: dockerhub-credentials
```

### Step 5: Add Kubeconfig
```
Manage Jenkins → Manage Credentials → Add
- Type: Secret File
- Upload your kubeconfig file
- ID: kubeconfig-media-compressor
```

### Step 6: Create New Pipeline Job
```
New Item → media-compressor-deployment → Pipeline
→ Pipeline script from SCM
Repository: https://github.com/SaikiranAsamwar/Media-Compressor-Devops.git
Script Path: jenkins/Jenkinsfile
```

### Step 7: Build & Deploy
```
Jenkins Dashboard → media-compressor-deployment → Build Now
```

---

## 📊 Pipeline Stages Overview

| Stage | Duration | What Happens | Status |
|-------|----------|--------------|--------|
| Checkout & Prepare | 2-3 min | Git clone, setup env | ✅ |
| Code Quality & Security | 5-10 min | SonarQube, npm audit | ✅ |
| Build & Test | 8-15 min | Build backend/frontend | ✅ |
| Docker Build & Push | 10-20 min | Build images, scan, push | ✅ |
| Deploy with Ansible | 5-10 min | Deploy to Kubernetes | ✅ |
| Health Checks | 3-5 min | Verify endpoints | ✅ |

---

## 🔐 Credentials Quick Reference

```
aws-credentials
├─ Type: AWS Credentials
├─ Contains: Access Key, Secret Key
└─ Used by: Docker build & push, EKS deployment

dockerhub-credentials
├─ Type: Username with Password
├─ Contains: Docker username & password
└─ Used by: Docker image push

kubeconfig-media-compressor
├─ Type: Secret File
├─ Contains: Kubernetes config file
└─ Used by: Ansible deployment

sonarqube-token (Optional)
├─ Type: Secret Text
├─ Contains: SonarQube authentication token
└─ Used by: Code quality scanning
```

---

## 🔧 Environment Variables to Update

File: `jenkins/Jenkinsfile`

```groovy
environment {
    AWS_REGION = 'us-west-2'                    # Your AWS region
    AWS_ACCOUNT_ID = '514439471441'            # Your AWS account ID
    ECR_REGISTRY = "514439471441.dkr.ecr.us-west-2.amazonaws.com"
    IMAGE_PREFIX = 'saikiranasamwar4'          # Your Docker registry
    CLUSTER_NAME = 'media-compressor-cluster'  # Your EKS cluster
    KUBECONFIG = credentials('kubeconfig-media-compressor')
}
```

---

## ✅ Pre-Deployment Checklist

- [ ] Jenkins installed and running
- [ ] All plugins installed
- [ ] AWS credentials configured
- [ ] Docker credentials added
- [ ] Kubeconfig file uploaded
- [ ] ECR repositories created
- [ ] EKS cluster created and accessible
- [ ] GitHub repository pushed
- [ ] Pipeline job created
- [ ] Environment variables updated
- [ ] GitHub webhook configured (optional)

---

## 🚨 Troubleshooting

### Issue: "Permission denied" on Kubeconfig
**Solution:**
```bash
chmod 600 ~/.kube/config
aws eks update-kubeconfig --region us-west-2 --name media-compressor-cluster
```

### Issue: "Failed to push image to ECR"
**Solution:**
```bash
aws ecr create-repository --repository-name saikiranasamwar4/media-compressor-backend
aws ecr create-repository --repository-name saikiranasamwar4/media-compressor-frontend
```

### Issue: "SonarQube connection failed"
**Solution:**
- Verify SonarQube server is running
- Check network connectivity
- Verify token is correct

### Issue: "Ansible connection timeout"
**Solution:**
```bash
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.general
```

---

## 📈 Monitoring Pipeline Progress

```bash
# View build logs
Jenkins Dashboard → media-compressor-deployment → Build #X → Console Output

# Real-time monitoring
Jenkins Dashboard → Blue Ocean → Pipeline visualization

# Verify deployment
kubectl get pods -n media-compressor -w

# Check logs
kubectl logs -f deployment/media-compressor-backend -n media-compressor
```

---

## 🔄 Rollback Procedure

```bash
# If deployment fails, rollback to previous version
kubectl rollout undo deployment/media-compressor-backend -n media-compressor
kubectl rollout undo deployment/media-compressor-frontend -n media-compressor

# Verify rollback
kubectl get deployment -n media-compressor
kubectl get pods -n media-compressor
```

---

## 📞 Support Commands

```bash
# Check Jenkins status
sudo systemctl status jenkins

# View Jenkins logs
tail -f /var/log/jenkins/jenkins.log

# Restart Jenkins
sudo systemctl restart jenkins

# Check EKS cluster
kubectl get nodes

# View all deployments
kubectl get all -n media-compressor

# Access application
kubectl port-forward service/media-compressor-backend 3000:3000 -n media-compressor
```

---

## 🎯 Expected Output on Success

```
✅ Checkout & Prepare: SUCCESS
✅ Code Quality & Security: SUCCESS (or warnings)
✅ Build & Test: SUCCESS
✅ Docker Build & Push: SUCCESS
   - Backend image: pushed
   - Frontend image: pushed
✅ Deploy with Ansible: SUCCESS
✅ Health Checks: SUCCESS
   - All endpoints responding
   - Services healthy
   - Deployment complete

Status: ✅ ALL GREEN - DEPLOYMENT SUCCESSFUL!
```

---

## 📝 Useful Deployment Commands

```bash
# Check image tags
aws ecr describe-images --repository-name saikiranasamwar4/media-compressor-backend

# View deployment status
kubectl describe deployment media-compressor-backend -n media-compressor

# Get service URL
kubectl get service media-compressor-lb -n media-compressor -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Scale deployment
kubectl scale deployment/media-compressor-backend --replicas=3 -n media-compressor

# Update image manually (if needed)
kubectl set image deployment/media-compressor-backend \
  backend=514439471441.dkr.ecr.us-west-2.amazonaws.com/saikiranasamwar4/media-compressor-backend:v42 \
  -n media-compressor
```

---

## 🎓 Next Steps After First Successful Deployment

1. **Setup Automated Deployments**
   - Configure GitHub webhook for automatic triggers
   - Enable branch protection rules

2. **Monitor Application**
   - Access Grafana dashboard
   - Review Prometheus metrics
   - Set up alerting

3. **Optimize Pipeline**
   - Add email notifications
   - Implement Slack notifications
   - Add approval steps for production

4. **Security Hardening**
   - Enable Jenkins authentication
   - Configure RBAC in Kubernetes
   - Add network policies

---

**Your Jenkins deployment is ready to go!** 🚀

For detailed information, see: `JENKINS_DEPLOYMENT_GUIDE.md`
