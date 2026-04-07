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