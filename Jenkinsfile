pipeline {
  options
  {
    buildDiscarder(logRotator(numToKeepStr: '3'))
  }
  agent any

  environment {
    IMAGE_REPO_NAME="ss-utopia-account"
    IMAGE_TAG="latest"
    REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
  }

  stages {       
    
    stage('checkout') {
      steps {
        git branch: "cloudformation", credentialsId: 'git_login', url: "https://github.com/byte-crunchers/ss-utopia-infrastructure.git"
      }
    }
    
    

    stage('Deploy Stack') {
      steps {
          script{
              sh 'aws cloudformation deploy --template-file cloudformation/ecsAll.yaml --stack-name ecsAll'
          }
      }
    }
    
  }
  post {
    always{
         cleanWs()
    }
  }
  
}
