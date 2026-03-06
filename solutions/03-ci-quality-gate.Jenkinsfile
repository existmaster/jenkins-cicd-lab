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

        // Quality Gate
        stage('Coverage Check') {
            steps {
                script {
                    def coverageFile = readFile('apps/backend/coverage/coverage-summary.json')
                    def coverage = readJSON text: coverageFile
                    def lineCoverage = coverage.total.lines.pct

                    echo "Backend Line Coverage: ${lineCoverage}%"

                    if (lineCoverage < 60) {
                        error "Coverage ${lineCoverage}% is below the 60% threshold"
                    }
                }
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: '**/test-results.xml'
            archiveArtifacts artifacts: '**/coverage/**', allowEmptyArchive: true
        }
        failure {
            echo 'CI Quality Gate 실패!'
        }
        success {
            echo 'CI Quality Gate 통과!'
        }
    }
}
