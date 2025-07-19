#!/bin/bash

set -e

minikube start --driver=docker
eval $(minikube docker-env)
docker build -t flask-app ./deploy/app
helm install flask-app ./deploy/helm/ --wait
minikube service flask-app