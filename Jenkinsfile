pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    tools {
        terraform 'terraform-1.0.9'
    }
    stages {
        
        stage('secret') {
        steps {
            withAWS(credentials: 'jenkins-ec2-user', region: 'us-east-1') {


            script {
                env.PASS = sh ( script: 'aws secretsmanager get-secret-value --secret-id some-name  | jq --raw-output .SecretString | jq -r ."password"', returnStdout: true)
                env.USER = sh(script: 'aws secretsmanager get-secret-value --secret-id some-name  | jq --raw-output .SecretString | jq -r ."username"',returnStdout: true)
                env.ENGINE = sh(script: 'aws secretsmanager get-secret-value --secret-id some-name  | jq --raw-output .SecretString | jq -r ."engine"',returnStdout: true)
                env.HOST = sh(script:'aws secretsmanager get-secret-value --secret-id some-name  | jq --raw-output .SecretString | jq -r ."host"', returnStdout: true)
            }
        }
        }
      }
      
        stage('Git Checkout') {
            steps {
                git branch: 'feature_terraform_DEV', url: 'https://github.com/byte-crunchers/ss-utopia-infrastructure.git'
            }
        }
        stage('Terraform Init') {
            steps {
                
                    sh '''terraform init \\
                    -backend-config="bucket=${bucket}" \\
                    -backend-config="key=${bucket_key}" \\
                    -backend-config="region=us-east-1" \\
                    -backend-config="access_key=${access_key}" \\
                    -backend-config="secret_key=${secret_key}" 
'''
                
            }
        }
        stage('Terraform Plan') {
            steps {
               
                     sh 'terraform plan'
                
            }
        }

        stage('Terraform Apply') {
            steps {
               
                     sh 'terraform ${command} -auto-approve -no-color'
                
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}