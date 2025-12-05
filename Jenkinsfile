pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    AWS_ACCOUNT = '514439471441'
    ECR_BACKEND = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/saikiranasamwar4/backend"
    ECR_FRONTEND = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/saikiranasamwar4/frontend"
  }

  stages {

    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Backend Build & Test') {
      steps {
        dir('backend') {
          sh 'npm ci'
          sh 'npm test || true'
        }
      }
    }

    stage('Frontend Build') {
      steps {
        dir('frontend') {
          sh 'npm ci'
          sh 'npm run build'
        }
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('SonarQube') {
          dir('backend') { sh 'sonar-scanner' }
          dir('frontend') { sh 'sonar-scanner' }
        }
      }
    }

    stage('Build & Push Docker Images') {
      steps {
        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        dir('backend') {
          sh "docker build -t backend:${BUILD_NUMBER} ."
          sh "docker tag backend:${BUILD_NUMBER} ${ECR_BACKEND}:${BUILD_NUMBER}"
          sh "docker push ${ECR_BACKEND}:${BUILD_NUMBER}"
        }

        dir('frontend') {
          sh "docker build -t frontend:${BUILD_NUMBER} ."
          sh "docker tag frontend:${BUILD_NUMBER} ${ECR_FRONTEND}:${BUILD_NUMBER}"
          sh "docker push ${ECR_FRONTEND}:${BUILD_NUMBER}"
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh """
        aws eks update-kubeconfig --name media-compressor-cluster --region us-east-1
        kubectl -n media-app set image deployment/backend backend=${ECR_BACKEND}:${BUILD_NUMBER}
        kubectl -n media-app set image deployment/frontend frontend=${ECR_FRONTEND}:${BUILD_NUMBER}
        kubectl -n media-app rollout status deployment/backend
        kubectl -n media-app rollout status deployment/frontend
        """
      }
    }
  }
}
