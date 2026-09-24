pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from Git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Docker image'
                bat 'docker build -t integrated-devops-app:latest .'
            }
        }

        stage('Test') {
            steps {
                echo 'Running application tests'
                bat 'docker run --rm -v "%CD%:/workspace" alpine:latest sh -c "cd /workspace && sh test/test.sh"'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application using Ansible'

                bat '''
                docker run --rm ^
                -v "%CD%:/ansible/project" ^
                -v //var/run/docker.sock:/var/run/docker.sock ^
                williamyeh/ansible:alpine3 ^
                ansible-playbook ^
                -i /ansible/project/ansible/inventory ^
                /ansible/project/ansible/deploy.yml
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed.'
        }
    }
}
