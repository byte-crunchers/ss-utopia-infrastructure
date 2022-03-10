#!/bin/bash
# eksctl utils associate-iam-oidc-provider --cluster ss-eks-cluster --approve
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
  --cluster=ss-eks-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::422288715120:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerAdditionalIAMPolicy \
  --policy-document file://iam_policy_v1_to_v2_additional.json

aws iam attach-role-policy \
--role-name eksctl-ss-eks-cluster-addon-iamserviceaccoun-Role1-B0X7IM27Y8SQ \
--policy-arn arn:aws:iam::422288715120:policy/AWSLoadBalancerControllerAdditionalIAMPolicy 

kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml


# kubectl apply -f alb-ServiceAccount.yaml
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

sed -i.bak -e 's|ss-eks-cluster|my-cluster|' ./v2_4_0_full.yaml
kubectl apply -f v2_4_0_full.yaml

kubectl  create ns demo
kubectl config set-context --current --namespace=demo
kubectl create secret docker-registry regcred --docker-server=${accountid}.dkr.ecr.${region}.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password) --namespace=demo
envsubst < ss-utopia-account-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-loan-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-user-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-auth-deployment.yaml | kubectl apply -f -
kubectl apply -f microservice-ingress.yaml