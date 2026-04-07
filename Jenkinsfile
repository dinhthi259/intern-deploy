pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('dockerhub-creds')
        MYSQL_PASSWORD = credentials('mysql-password')
    }

    stages {

        stage('Login DockerHub') {
            steps {
                sh '''
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                '''
            }
        }

        stage('Pull Latest Images') {
            steps {
                sh 'docker-compose pull'
            }
        }

        stage('Stop Old Containers') {
            steps {
                sh 'docker-compose down || true'
            }
        }

        stage('Run New Containers') {
            steps {
                sh '''
                export MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD
                docker-compose up -d
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                docker build -t dinhthi2509/kltn-backend:latest ./backend
                docker build -t dinhthi2509/kltn-frontend:latest ./frontend

                docker push dinhthi2509/kltn-backend:latest
                docker push dinhthi2509/kltn-frontend:latest
                '''
            }
        }       

        stage('Check Running') {
            steps {
                sh 'docker ps'
            }
        }

    }

    post {
        success {
            echo '✅ Deploy thành công!'
        }
        failure {
            echo '❌ Deploy thất bại!'
        }
    }
}