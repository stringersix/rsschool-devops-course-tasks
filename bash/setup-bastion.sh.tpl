#!/bin/bash

set -e

# Enable IP forwarding and NAT

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Create .ssh folder

mkdir -p /home/ec2-user/.ssh
chown ec2-user:ec2-user /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

# Write private key

cat <<'EOF' > /home/ec2-user/.ssh/id_rsa
${private_key}
EOF

chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa

# Create ssh config

cat <<'EOF' > /home/ec2-user/.ssh/config
Host 10.0.*
  User ec2-user
  IdentityFile /home/ec2-user/.ssh/id_rsa
  StrictHostKeyChecking no
EOF

chown ec2-user:ec2-user /home/ec2-user/.ssh/config
chmod 600 /home/ec2-user/.ssh/config



# install kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

mkdir -p /home/ec2-user/.kube
chown ec2-user:ec2-user /home/ec2-user/.kube

# wait k3s.yaml on master (60 seconds)
for i in {1..30}; do
  ssh -i /home/ec2-user/.ssh/id_rsa -o StrictHostKeyChecking=no ec2-user@${master_ip} "sudo test -f /etc/rancher/k3s/k3s.yaml" && break
  echo "k3s.yaml not found yet, retrying..."
  sleep 2
done

# Copy kubeconfig from master
ssh -i /home/ec2-user/.ssh/id_rsa -o StrictHostKeyChecking=no ec2-user@${master_ip} "sudo cat /etc/rancher/k3s/k3s.yaml" > /home/ec2-user/.kube/config

# replace IP in kubeconfig
sed -i "s/127.0.0.1/${master_ip}/g" /home/ec2-user/.kube/config
chown ec2-user:ec2-user /home/ec2-user/.kube/config
chmod 600 /home/ec2-user/.kube/config