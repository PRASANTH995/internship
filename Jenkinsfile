pipeline {
  agent any

  environment {
    IMAGE_NAME = "flask-cicd-internship"
    DOCKERHUB_USER = "Prash"
    DOCKERHUB_PASS = "Abc@123"
    DOCKER_IMAGE_TAG = "latest"
    EC2_USER = "ec2-user"
    EC2_HOST = "<EC2_PUBLIC_IP>" // Update this with your EC2 IP
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${DOCKER_IMAGE_TAG} .'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'docker run --rm ${IMAGE_NAME}:${DOCKER_IMAGE_TAG} pytest -q'
      }
    }

    stage('Lint') {
      steps {
        sh 'docker run --rm ${IMAGE_NAME}:${DOCKER_IMAGE_TAG} flake8 .'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        sh '''
          echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
          docker tag ${IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG}
          docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG}
        '''
      }
    }

    stage('Deploy to EC2') {
      when { expression { return env.EC2_HOST != "<EC2_PUBLIC_IP>" } }
      steps {
        sshagent (credentials: ['ec2-ssh-key']) {
          sh '''
            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "
              docker rm -f flask-app || true &&
              docker pull ${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG} &&
              docker run -d --name flask-app -p 80:5000 ${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG}
            "
          '''
        }
      }
    }
  }
}
