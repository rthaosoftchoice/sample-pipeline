pipeline {
    agent any

    stages {

        // stage('Initialize') {
        //     steps {
        //         // Install Terraform
        //         sh 'curl -LO https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip'
        //         sh 'unzip -o terraform_0.15.4_linux_amd64.zip'
        //         sh 'mv terraform /usr/local/bin/'

        //         // Initialize Azure credentials
        //         // azureCredentialsBinding(
        //         //     credentialsId: 'your-azure-credentials-id',
        //         //     subscriptionId: 'your-subscription-id',
        //         //     tenantId: 'your-tenant-id'
        //         // )
        //     }
        // }

        stage('Initilize') {
            environment {
                // Set Azure credentials for the deployment
                AZURE_CREDENTIALS = credentials('Azure')
            }
            steps {
                // Deploy Terraform infrastructure to Azure
                sh 'terraform init'
            }
        }

        stage('Deploy') {
            steps {
                // Deploy Terraform infrastructure to Azure
                sh 'terraform plan -out=tfplan'
                sh 'terraform apply -input=false tfplan'
            }        
        }

        // stage('Destroy') {
        //     environment {
        //         // Set Azure credentials for the destruction
        //         AZURE_CREDENTIALS = credentials('your-azure-credentials-id')
        //     }
        //     steps {
        //         // Destroy Terraform infrastructure in Azure
        //         sh 'terraform init'
        //         sh 'terraform destroy -auto-approve'
        //     }
        // }
    }
}
