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

        stage('Ansible Configuration') {
            steps {
                echo 'Running Ansible configuration management'

                bat '''
                docker run --rm ^
                -v "%CD%:/ansible/project" ^
                williamyeh/ansible:alpine3 ^
                ansible-playbook ^
                -i /ansible/project/ansible/inventory ^
                /ansible/project/ansible/deploy.yml
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Docker container'

                bat '''
                docker rm -f integrated-devops-app 2>nul
                docker run -d --name integrated-devops-app -p 8085:80 integrated-devops-app:latest
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployed container'

                bat '''
                docker ps --filter "name=integrated-devops-app"
                echo Application deployed on http://localhost:8085
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
