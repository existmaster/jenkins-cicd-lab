// LO9 완성: 전체 파이프라인 (triggers + Telegram 알림)
// pollSCM으로 자동 빌드, Telegram으로 결과 알림

pipeline {
    agent any

    tools {
        nodejs 'node20'
    }

    triggers {
        pollSCM('H/2 * * * *')
    }

    environment {
        CI = 'true'
        NODE_ENV = 'test'
        TELEGRAM_BOT_TOKEN = credentials('telegram-bot-token')
        TELEGRAM_CHAT_ID = credentials('telegram-chat-id')
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

        // Parallel CI
        stage('CI') {
            parallel {
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
            }
        }

        // Docker Build
        stage('Docker Build') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        dir('apps/backend') {
                            sh "docker build -t backend:${BUILD_NUMBER} ."
                            sh "docker tag backend:${BUILD_NUMBER} backend:latest"
                        }
                    }
                }
                stage('Build Frontend Image') {
                    steps {
                        dir('apps/frontend') {
                            sh "docker build -t frontend:${BUILD_NUMBER} ."
                            sh "docker tag frontend:${BUILD_NUMBER} frontend:latest"
                        }
                    }
                }
            }
        }

        // Deploy to Staging
        stage('Deploy Staging') {
            steps {
                sh '''
                    export BUILD_NUMBER=${BUILD_NUMBER}
                    docker compose -f docker-compose.staging.yml down || true
                    docker compose -f docker-compose.staging.yml up -d
                '''
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
        stage('Deploy Production') {
            steps {
                sh '''
                    export BUILD_NUMBER=${BUILD_NUMBER}
                    docker compose -f docker-compose.prod.yml down || true
                    docker compose -f docker-compose.prod.yml up -d
                '''
                sh '''
                    sleep 5
                    curl -f http://backend-prod:4000/health || exit 1
                    echo "Production 배포 성공"
                '''
            }
        }
    }

    post {
        success {
            sh '''
                curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
                  --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
                  --data-urlencode "parse_mode=HTML" \
                  --data-urlencode "text=<b>Jenkins CI/CD</b>
<b>Build:</b> #${BUILD_NUMBER}
<b>Status:</b> SUCCESS
<b>Staging:</b> Backend :3000 / Frontend :3001
<b>Production:</b> Backend :4000 / Frontend :4001"
            '''
        }
        failure {
            sh '''
                curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
                  --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
                  --data-urlencode "parse_mode=HTML" \
                  --data-urlencode "text=<b>Jenkins CI/CD</b>
<b>Build:</b> #${BUILD_NUMBER}
<b>Status:</b> FAILED
<b>Check:</b> ${BUILD_URL}"
            '''
        }
    }
}
