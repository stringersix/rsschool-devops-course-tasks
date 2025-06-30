#!/bin/bash

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