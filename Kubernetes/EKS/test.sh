#!/bin/bash
kubectl create secret docker-registry regcred --docker-server=${account_id}.dkr.ecr.${region}.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password) --namespace=demo