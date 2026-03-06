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

        // Parallel CI
        stage('CI') {
            parallel {
                stage('Backend CI') {
                    stages {
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
                    }
                }

                stage('Frontend CI') {
                    stages {
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
                    }
                }
            }
        }

        // Docker Build
        stage('Docker Build') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        dir('apps/backend') {
                            sh "docker build -t todo-backend:${BUILD_NUMBER} ."
                            sh "docker tag todo-backend:${BUILD_NUMBER} todo-backend:latest"
                        }
                    }
                }
                stage('Build Frontend Image') {
                    steps {
                        dir('apps/frontend') {
                            sh "docker build -t todo-frontend:${BUILD_NUMBER} ."
                            sh "docker tag todo-frontend:${BUILD_NUMBER} todo-frontend:latest"
                        }
                    }
                }
            }
        }

        // Deploy to Staging
        stage('Deploy to Staging') {
            steps {
                sh "docker compose -f docker-compose.staging.yml down || true"
                sh "BUILD_NUMBER=${BUILD_NUMBER} docker compose -f docker-compose.staging.yml up -d"
                sh '''
                    sleep 5
                    curl -f http://backend-staging:3000/health || exit 1
                    echo "Staging 배포 성공"
                '''
            }
        }

        // Manual Approval
        stage('Approval') {
            options {
                timeout(time: 30, unit: 'MINUTES')
            }
            steps {
                input message: 'Staging 확인 완료. Production에 배포하시겠습니까?',
                      ok: '배포 승인',
                      submitter: 'admin'
            }
        }

        // Deploy to Production
        stage('Deploy to Production') {
            steps {
                sh "docker compose -f docker-compose.prod.yml down || true"
                sh "BUILD_NUMBER=${BUILD_NUMBER} docker compose -f docker-compose.prod.yml up -d"
                sh '''
                    sleep 5
                    curl -f http://backend-prod:4000/health || exit 1
                    echo "Production 배포 성공"
                '''
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
            echo "전체 파이프라인 성공 (Build #${BUILD_NUMBER})"
        }
    }
}
