pipeline {
    agent any
    stages {
        stage('Proxy') {
            steps {
                sh 'export https_proxy="http://192.168.101.49:7890"'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('ci') {
            steps {
                sh 'chmod +x ./jenkins/scripts/ci.sh'
                sh './jenkins/scripts/ci.sh'
            }
        }
        stage('push-to-docker-hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub-id', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
                        sh "docker login -u $usr -p $pwd"
                        sh "docker push jiangchengyu/`mvn -q -DforceStdout help:evaluate -Dexpression=project.name`"
                }
            }
        }
        stage('cd') {
            steps {
                sh "kubectl apply -f k8s/*"
            }
        }
    }
}