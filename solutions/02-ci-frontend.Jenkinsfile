// LO5 완성: Frontend CI 파이프라인
// Jenkinsfile.frontend 파일로 저장합니다 (Script Path: Jenkinsfile.frontend)

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
                dir('apps/frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Lint') {
            steps {
                dir('apps/frontend') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Build') {
            steps {
                dir('apps/frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Test') {
            steps {
                dir('apps/frontend') {
                    sh 'npm test'
                }
            }
            post {
                always {
                    dir('apps/frontend') {
                        junit 'test-results.xml'
                    }
                }
            }
        }
    }

    post {
        failure {
            echo 'Frontend CI 실패!'
        }
        success {
            echo 'Frontend CI 성공!'
        }
    }
}
