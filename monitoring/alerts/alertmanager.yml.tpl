global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: '${SMTP_EMAIL}'
  smtp_auth_username: '${SMTP_EMAIL}'
  smtp_auth_password: '${SMTP_PASS}'
  smtp_require_tls: true

route:
  receiver: 'email'

receivers:
- name: 'email'
  email_configs:
  - to: '${SMTP_EMAIL}'