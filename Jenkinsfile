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

                bat '''
                if not exist index.html exit /b 1
                findstr /C:"Integrated DevOps Project" index.html
                if errorlevel 1 exit /b 1
                echo All application tests passed successfully.
                '''
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
