pipeline{
    agent any 
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }
    environment {
        TF_HOME = tool('terraform')
        TF_VERSION = "1.5.1" // Replace with your desired Terraform version        
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
    }
    stages {
        stage('Install Terraform') {
            steps {
                sh "curl -LO https://releases.hashicorp.com/terraform/${env.TF_VERSION}/terraform_${env.TF_VERSION}_linux_amd64.zip"
                sh "unzip terraform_${env.TF_VERSION}_linux_amd64.zip"
                sh "chmod +x terraform"
                sh "sudo mv terraform /usr/local/bin/"
                sh "terraform version"
            }
        }
        
        stage('Terraform Init'){
            
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'Azure',
                    subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                    clientIdVariable: 'AZURE_CLIENT_ID',
                    clientSecretVariable: 'AZURE_CLIENT_SECRET',
                    tenantIdVariable: 'AZURE_TENANT_ID'
                ), string(credentialsId: 'access_key', variable: 'AZURE_ACCESS_KEY')]) {
                        
                        sh """
                                
                        echo "Initialising Terraform"
                        terraform init -backend-config="access_key=$AZURE_ACCESS_KEY"
                        """
                           }
                    }
             }
        }

        stage('Terraform Validate'){
            
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'Jenkins',
                    subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                    clientIdVariable: 'AZURE_CLIENT_ID',
                    clientSecretVariable: 'AZURE_CLIENT_SECRET',
                    tenantIdVariable: 'AZURE_TENANT_ID'
                ), string(credentialsId: 'access_key', variable: 'AZURE_ACCESS_KEY')]) {
                        
                        sh """
                                
                        terraform validate
                        """
                           }
                    }
             }
        }

        stage('Terraform Plan'){
            steps {

                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'Jenkins',
                    subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                    clientIdVariable: 'AZURE_CLIENT_ID',
                    clientSecretVariable: 'AZURE_CLIENT_SECRET',
                    tenantIdVariable: 'AZURE_TENANT_ID'
                ), string(credentialsId: 'access_key', variable: 'AZURE_ACCESS_KEY')]) {
                        
                        sh """
                        
                        echo "Creating Terraform Plan"
                        terraform plan -var "client_id=$AZURE_CLIENT_ID" -var "client_secret=$AZURE_CLIENT_SECRET" -var "subscription_id=$AZURE_SUBSCRIPTION_ID" -var "tenant_id=$AZURE_TENANT_ID"
                        """
                        }
                }
            }
        }

        stage('Waiting for Approval'){
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input (message: "Deploy the infrastructure?")
                }
            }
        
        }
    

        stage('Terraform Apply'){
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'Jenkins',
                    subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                    clientIdVariable: 'AZURE_CLIENT_ID',
                    clientSecretVariable: 'AZURE_CLIENT_SECRET',
                    tenantIdVariable: 'AZURE_TENANT_ID'
                ), string(credentialsId: 'access_key', variable: 'AZURE_ACCESS_KEY')]) {

                        sh """
                        echo "Applying the plan"
                        terraform apply -auto-approve -var "client_id=$AZURE_CLIENT_ID" -var "client_secret=$AZURE_CLIENT_SECRET" -var "subscription_id=$AZURE_SUBSCRIPTION_ID" -var "tenant_id=$AZURE_TENANT_ID"
                        """
                                }
                }
            }
        }

    }
}
