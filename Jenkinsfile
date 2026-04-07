pipeline {
    agent any

    stages {

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