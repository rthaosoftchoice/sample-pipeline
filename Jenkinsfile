pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'Azure' // ID of the Azure service principal credential in Jenkins
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan -input=false'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDENTIALS_ID)]) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}
