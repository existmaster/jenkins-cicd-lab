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

    post {
        failure {
            echo 'Backend CI 실패!'
        }
        success {
            echo 'Backend CI 성공!'
        }
    }
}
