# rsschool-devops-course-tasks

- Follow the instructions to install [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Follow the instructions to install [Terraform 1.6+](https://developer.hashicorp.com/terraform/install?product_intent=terraform).
- You need to create S3 bucket via AWS cli. You can also create it via core folder though terraform (with configuring private github action connect).
- Create key-pair in your AWS console
- Create terraform.tvars file in root directory and add to it:

```
bastion_key = <key-pair-name>
allowed_ip  = <Ip-address / CIDR>
```

- in root directory run commands:

```
terraform init -backend-config="bucket_name=<your-created-s3-bucket-name-here>" -backend-config="region=<your-region>
terraform plan
terraform apply -auto-approve
```

- after all the jobs is done, you can make a request to public instances

```
curl http://<your-public-instance-ip>
```

- also you can connect via ssh to the bastion-host (you can watch ip address from output).

```
ssh -i <path-to-created-key.pem> ec2-user@<bastion_public_ip>
```

- then you can connect to your private network (see ip in output)

```
ssh ec2-user@<private_instance_ip>
```
