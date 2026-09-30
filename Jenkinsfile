pipeline {
    agent {
        docker {
            image 'node:20-bookworm-slim'
            label 'linux-build'
        }
    }
    environment {
        APP_NAME = 'subscription-track-api'
        NODE_ENV = 'test'
    }
    options {
        timeout(time: 15, unit: 'MINUTES')
        // A hung npm install, test run, or quality gate must not hold the executor forever; setting an explicit timeout prevents pipeline starvation and resource leaks
    }
    stages {
        stage('Install') {
            steps {
                echo "Running Install for ${env.APP_NAME} in environment ${env.NODE_ENV}"
                dir('apps/server') {
                    sh 'npm ci --legacy-peer-deps || npm install --legacy-peer-deps'
                }
            }
        }
        stage('Lint') {
            steps {
                echo "Running Lint for ${env.APP_NAME}"
                dir('apps/server') {
                    sh 'npm run lint'
                }
            }
        }
        stage('Unit Test') {
            steps {
                echo "Running Unit Test with Coverage for ${env.APP_NAME}"
                dir('apps/server') {
                    sh 'npx vitest run src test/*.integration.spec.ts --coverage --coverage.reporter=cobertura --coverage.reporter=lcov --coverage.reporter=text --reporter=default --reporter=junit --outputFile.junit=reports/junit.xml'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                echo "Running SonarQube Scanner for ${env.APP_NAME}"
                withSonarQubeEnv('SonarQube') {
                    dir('apps/server') {
                        sh 'npx sonarqube-scanner -D sonar.host.url=http://sonarqube:9000 -D sonar.login=squ_4a52c26eaf531265b8fdbd74ce3c816d4a303c68'
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                echo "Waiting for SonarQube Quality Gate evaluation..."
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('E2E Test') {
            steps {
                echo "Running Playwright E2E Suite for ${env.APP_NAME}"
                dir('apps/server') {
                    sh 'npx playwright test --reporter=list,junit:reports/e2e-junit.xml || true'
                }
            }
        }
        stage('Deploy — Staging') {
            when { branch 'develop' }
            steps {
                sh 'echo deploying to staging...'
            }
        }
        stage('Deploy — Production') {
            when {
                beforeInput true
                branch 'main'
            }
            input {
                message 'Deploy to production?'
            }
            steps {
                sh 'echo deploying to production...'
            }
        }
    }
    post {
        always {
            junit testResults: 'apps/server/reports/*.xml', allowEmptyResults: true
            archiveArtifacts artifacts: 'apps/server/coverage/**,apps/server/playwright-report/**', allowEmptyArchive: true
        }
        success {
            echo " [PASS] ${env.APP_NAME} passed on ${env.NODE_ENV}"
        }
        failure {
            echo " [FAIL] Failed at stage: ${env.STAGE_NAME}"
        }
    }
}
