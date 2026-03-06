pipeline {
    agent any

    tools {
        nodejs 'node20'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // Backend CI
        stage('Backend - Install') {
            steps {
                dir('apps/backend') {
                    sh 'npm install'
                }
            }
        }

        stage('Backend - Lint') {
            steps {
                dir('apps/backend') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Backend - Test') {
            steps {
                dir('apps/backend') {
                    sh 'npm test'
                }
            }
        }

        // Frontend CI
        stage('Frontend - Install') {
            steps {
                dir('apps/frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Frontend - Lint') {
            steps {
                dir('apps/frontend') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Frontend - Build') {
            steps {
                dir('apps/frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Frontend - Test') {
            steps {
                dir('apps/frontend') {
                    sh 'npm test'
                }
            }
        }

        // Docker Build
        stage('Docker Build - Backend') {
            steps {
                dir('apps/backend') {
                    sh "docker build -t todo-backend:${BUILD_NUMBER} ."
                    sh "docker tag todo-backend:${BUILD_NUMBER} todo-backend:latest"
                }
            }
        }

        stage('Docker Build - Frontend') {
            steps {
                dir('apps/frontend') {
                    sh "docker build -t todo-frontend:${BUILD_NUMBER} ."
                    sh "docker tag todo-frontend:${BUILD_NUMBER} todo-frontend:latest"
                }
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: '**/test-results.xml'
        }
        failure {
            echo 'CI/CD 파이프라인 실패!'
        }
        success {
            echo "Docker 이미지 빌드 완료 (Build #${BUILD_NUMBER})"
        }
    }
}
