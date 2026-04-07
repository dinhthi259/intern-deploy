pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DOCKER_IMAGE_BACKEND = 'dinhthi2509/kltn-backend'
        DOCKER_IMAGE_FRONTEND = 'dinhthi2509/kltn-frontend'
        IMAGE_TAG = "${env.BUILD_NUMBER}"   // version theo build
    }

    stages {

        // 🔹 1. Checkout source
        stage('Checkout') {
            steps {
                git 'https://github.com/dinhthi259/intern-deploy.git'
            }
        }

        // 🔹 2. Build Docker Image
        stage('Build Images') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE_BACKEND:$IMAGE_TAG ./backend
                docker build -t $DOCKER_IMAGE_FRONTEND:$IMAGE_TAG ./frontend
                '''
            }
        }

        // 🔹 3. Login DockerHub (secure)
        stage('Login DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKERHUB_CREDENTIALS,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        // 🔹 4. Push Image
        stage('Push Images') {
            steps {
                sh '''
                docker push $DOCKER_IMAGE_BACKEND:$IMAGE_TAG
                docker push $DOCKER_IMAGE_FRONTEND:$IMAGE_TAG

                # tag latest
                docker tag $DOCKER_IMAGE_BACKEND:$IMAGE_TAG $DOCKER_IMAGE_BACKEND:latest
                docker tag $DOCKER_IMAGE_FRONTEND:$IMAGE_TAG $DOCKER_IMAGE_FRONTEND:latest

                docker push $DOCKER_IMAGE_BACKEND:latest
                docker push $DOCKER_IMAGE_FRONTEND:latest
                '''
            }
        }

        // 🔹 5. Deploy (CD)
        stage('Deploy') {
            steps {
                sh '''
                docker-compose down || true
                docker-compose pull
                docker-compose up -d
                '''
            }
        }

        // 🔹 6. Verify
        stage('Check Running') {
            steps {
                sh 'docker ps'
            }
        }
    }

    post {
        success {
            echo "✅ Deploy thành công!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}