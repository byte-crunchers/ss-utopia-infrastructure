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
        git branch: "eks", credentialsId: 'git_login', url: "https://github.com/byte-crunchers/ss-utopia-infrastructure.git"
      }
    }
    
    

    stage('Create Cluster') {
      steps {
          script{
              dir('eks') {
                  sh """
            [ ! -d bin ] && mkdir bin
            ( cd bin
            curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_\$(uname -s)_amd64.tar.gz" | tar xzf -
            # 'latest' kubectl is backward compatible with older api versions
            curl --silent -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
            curl -fsSL -o - https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar -xzf - linux-amd64/helm
            mv linux-amd64/helm .
            rm -rf linux-amd64
            chmod u+x eksctl kubectl helm
            ls -l eksctl kubectl helm )
            
          """
        
            sh 'eksctl version'
                sh 'eksctl create cluster -f Cluster.yaml'
                }
             
          }
      }
    }
    
    stage('deploy eks') {
      steps {
          script{
              dir('eks') {
                sh  'kubectl  create ns demo'
                sh 'kubectl config set-context --current --namespace=demo'
                sh """eksctl utils associate-iam-oidc-provider --cluster ss-eks-cluster --approve

                eksctl create iamserviceaccount \
                  --cluster=ss-eks-cluster \
                  --namespace=kube-system \
                  --name=aws-load-balancer-controller \
                  --attach-policy-arn=arn:aws:iam::422288715120:policy/AWSLoadBalancerControllerIAMPolicy \
                  --override-existing-serviceaccounts \
                  --approve

                aws iam attach-role-policy \
                  --role-name eksctl-ss-eks-cluster-addon-iamserviceaccoun-Role1-B0X7IM27Y8SQ \
                  --policy-arn arn:aws:iam::422288715120:policy/AWSLoadBalancerControllerAdditionalIAMPolicy """
                sh 'kubectl apply --validate=false  -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml'
                sh 'kubectl create secret docker-registry regcred --docker-server=422288715120.dkr.ecr.us-east-1.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password) --namespace=demo'
                sh 'kubectl apply -f alb-ServiceAccount.yaml'
                sh 'kubectl apply -f v2_3_0_full.yaml'
                sh 'kubectl kustomize | kubectl apply -f -'
                sh 'kubectl describe ingress  ingress'
                
                }
             
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
