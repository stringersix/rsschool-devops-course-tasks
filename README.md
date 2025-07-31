# rsschool-devops-course-tasks

<!-- - Follow the instructions to install [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Follow the instructions to install [Terraform 1.6+](https://developer.hashicorp.com/terraform/install?product_intent=terraform).
- Install make (here example for Ubuntu):

```
sudo apt update
sudo apt install make
```

- Create key-pair in your AWS console
- Create and fill in the `.env` file. Use `.env.example` as an example.
- in root directory run commands:

```
make init-core
make apply-core
make init
make apply
```

- After all jobs you can connect via ssh to the bastion-host (you can watch ip address from output):

```
ssh -i <path-to-created-key.pem> ec2-user@<bastion_public_ip>
```

- run command on bastion:

```
export KUBECONFIG=~/.kube/config && kubectl get nodes
```

- After that, you can destroy everything.

```
make destroy
make destroy-core
``` -->

<!-- - install docker
```
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

- install kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```
- install minikube
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```
- install helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

- run deploy by script or do it manually (see next step)
```
bash deploy/setup.sh
```

- run minikube
```
minikube start --driver=docker
```

- connect docker to minikube
```
eval $(minikube docker-env)
```

- build image (in minikube enviroment)
```
docker build -t flask-app .
```

- install chart (from root)

```
helm install flask-app ./deploy/helm/ --wait
```

- host and check it in browser (use link from output)
```
minikube service flask-app
```

- after all you can uninstall it
```
helm uninstall flask-app
minikube stop --all
minikube delete --all
``` -->
<!-- 

- install docker
```
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

- install kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```
- install minikube
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```
- install helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

- install jenkins chart

```
helm upgrade --install jenkins jenkins/jenkins   -n jenkins --create-namespace   -f jenkins/helm/values.yaml
```

- apply admin binding

```
kubectl apply -f jenkins/admin-binding.yaml
```

- create dockerconfig secret creds for kaniko
```
kubectl create secret generic docker-config   --from-file=.dockerconfigjson=./config.json   --type=kubernetes.io/dockerconfigjson   -n jenkins
```

- host and check it in browser (use link from output). login and password - "admin"

```
minikube service jenkins -n jenkins
```

- provide vars discord-webhook and sonar-token (secret text)

- create pipeline (path to jenkinsfile: jenkins/Jenkinsfile)

- run pipeline and enjoy! -->


init task 7

- install docker
```
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

- install kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```
- install minikube
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```
- install helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

- add repos to helm

```
helm repo add jenkins https://charts.jenkins.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

- install make 
```
sudo apt update
sudo apt install make -y
```

- run minikube 
```
minikube start --driver=docker
```

- create and fill .env file in root as .env.example

- install jenkins via make command (you need to provide docker-config file to the project root as "сonfig.json")
```
make setup-jenkins
```

- install monitoring tools via make command or (see next)
```
make setup-monitoring
```

- host jenkins in browser (use link from output), then configure and run pipeline. login and password - "admin"

```
minikube service jenkins -n jenkins
```

- after all jobs done, host grafana in browser
```
minikube service prom-stack-grafana -n monitoring
```