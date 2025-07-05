#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Привет</title>
</head>
<body style="background: yellow; display: flex; justify-content: center; align-items: center; height: 100vh;">
  <h1>Привет Мир!</h1>
</body>
</html>
EOF
systemctl start nginx