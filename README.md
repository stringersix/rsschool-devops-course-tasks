# rsschool-devops-course-tasks

- Follow the instructions to install [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Follow the instructions to install [Terraform 1.6+](https://developer.hashicorp.com/terraform/install?product_intent=terraform).
- You need to create S3 bucket via AWS cli. You can also create it via core folder though terraform (with configuring private github action connect).
- in root directory run commands:

```
terraform init -backend-config="bucket_name=<your-created-s3-bucket-name-here>" -backend-config="region=<your-region>
terraform plan
terraform apply -auto-approve
```
