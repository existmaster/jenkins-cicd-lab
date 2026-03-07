// LO4 완성: Backend CI 파이프라인
// Jenkinsfile을 이 내용으로 교체합니다

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

        stage('Install') {
            steps {
                dir('apps/backend') {
                    sh 'npm install'
                }
            }
        }

        stage('Lint') {
            steps {
                dir('apps/backend') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Test') {
            steps {
                dir('apps/backend') {
                    sh 'npm test'
                }
            }
            post {
                always {
                    dir('apps/backend') {
                        junit 'test-results.xml'
                    }
                }
            }
        }
    }
}

