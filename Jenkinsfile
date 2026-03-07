// LO7 완성: 통합 Jenkinsfile (CI + Docker Build)
// Backend CI, Frontend CI, Docker Build를 하나의 Jenkinsfile로 통합합니다

pipeline {
    agent any

    tools {
        nodejs 'node20'
    }

    environment {
        CI = 'true'
        NODE_ENV = 'test'
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend CI') {
            stages {
                stage('Backend Install') {
                    steps {
                        dir('apps/backend') {
                            sh 'npm install'
                        }
                    }
                }
                stage('Backend Lint') {
                    steps {
                        dir('apps/backend') {
                            sh 'npm run lint'
                        }
                    }
                }
                stage('Backend Test') {
                    steps {
                        dir('apps/backend') {
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Frontend CI') {
            stages {
                stage('Frontend Install') {
                    steps {
                        dir('apps/frontend') {
                            sh 'npm install'
                        }
                    }
                }
                stage('Frontend Lint') {
                    steps {
                        dir('apps/frontend') {
                            sh 'npm run lint'
                        }
                    }
                }
                stage('Frontend Build') {
                    steps {
                        dir('apps/frontend') {
                            sh 'npm run build'
                        }
                    }
                }
                stage('Frontend Test') {
                    steps {
                        dir('apps/frontend') {
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t backend:${BUILD_NUMBER} apps/backend/
                    docker build -t frontend:${BUILD_NUMBER} apps/frontend/
                '''
            }
        }
        
        stage('Deploy Staging') {
            steps {
                sh '''
                    export BUILD_NUMBER=${BUILD_NUMBER}
                    docker compose -f docker-compose.staging.yml down || true
                    docker compose -f docker-compose.staging.yml up -d
                '''
                sh '''
                    sleep 5
                    curl -f http://backend-staging:3000/api/health || exit 1
                    echo "Staging 배포 성공"
                '''
            }
        }
    }
}
