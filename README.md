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
```


