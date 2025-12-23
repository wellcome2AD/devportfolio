pipeline {
    agent any
    environment {
        IMAGE = 'username/devportfolio'
        TAG = "${BUILD_NUMBER}-${GIT_COMMIT[0..7]}"
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t $IMAGE:$TAG .'
            }
        }
        stage('Scan') {
            steps {
                sh 'docker run --rm aquasec/trivy image $IMAGE:$TAG --severity HIGH,CRITICAL'
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub',
                    usernameVariable: 'U',
                    passwordVariable: 'P'
                )]) {
                    sh 'echo $P | docker login -u $U --password-stdin'
                    sh 'docker push $IMAGE:$TAG'
                }
            }
        }
    }
}
