kubectl create ns demo
kubectl config set-context --current --namespace=demo
kubectl create secret docker-registry regcred --docker-server=${account_id}.dkr.ecr.${region}.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password) --namespace=demo
kubectl apply -f ingress-nginx-controller.yaml
envsubst < ss-utopia-account-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-loan-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-user-deployment.yaml | kubectl apply -f -
envsubst < ss-utopia-auth-deployment.yaml | kubectl apply -f -
kubectl apply -f microservice-ingress.yaml
kubectl get svc --all-namespaces
