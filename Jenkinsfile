pipeline {
    agent any

    environment {
    // Set Azure credentials for the deployment
    AZURE_CREDENTIALS = credentials('azure-rthao-service-principle')
}

    stages {
            stage('Initialize') {
            steps {
                // Install Terraform
                sh 'curl -LO https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip'
                sh 'unzip -o terraform_0.15.4_linux_amd64.zip'
                sh 'pwd'
                sh 'mv -o terraform $WORKSPACE'
            }
        }

        // stage('Initialize') {
        //     steps {
        //         // // Install Terraform
        //         // sh 'curl -LO https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip'
        //         // sh 'unzip -o terraform_0.15.4_linux_amd64.zip'
        //         // sh 'mv terraform /usr/local/bin/'

        //         Initialize Azure credentials
        //         azureCredentialsBinding(
        //             credentialsId: 'AZURE_CREDENTIALS',
        //             subscriptionId: 'AZURE_CREDENTIALS_SUBSCRIPTION_ID',
        //             tenantId: 'AZURE_CREDENTIALS_TENANT_ID'
        //         )
        //     }
        // }

        stage('Terraform Initilize') {
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
