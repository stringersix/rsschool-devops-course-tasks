# rsschool-devops-course-tasks

- Follow the instructions to install [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Follow the instructions to install [Terraform 1.6+](https://developer.hashicorp.com/terraform/install?product_intent=terraform).
- Create S3 bucket (via aws cli)
- in project directory run commands:

```
terraform init -backend-config="bucket=<your-s3-bucket-name-here>"
terraform plan
terraform apply -auto-approve
```
