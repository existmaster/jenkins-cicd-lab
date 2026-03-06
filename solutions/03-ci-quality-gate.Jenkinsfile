// LO6: 품질 게이트
// Jenkinsfile 자체는 01과 동일합니다.
// 이 챕터의 핵심은 vitest.config.js에 커버리지 임계값을 설정하는 것입니다.
//
// vitest.config.js에 추가할 내용:
//   test: {
//     coverage: {
//       provider: 'v8',
//       reporter: ['text', 'json-summary'],
//       thresholds: { lines: 60, branches: 60, functions: 60, statements: 60 }
//     }
//   }

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
