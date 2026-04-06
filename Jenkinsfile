pipeline {
    agent any

    environment {
        PROJECT_NAME = "intern-deploy"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/dinhthi259/intern-deploy.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Stop Old Containers') {
            steps {
                sh 'docker-compose down || true'
            }
        }

        stage('Run New Containers') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Check Running') {
            steps {
                sh 'docker ps'
            }
        }
       
    }
}
