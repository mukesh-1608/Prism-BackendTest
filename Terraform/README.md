# GENAI Project infrastructure setup scripts

## Pre-Requisite

Please install the below mentioned tools

```bash
    AWS CLI
```
Configure the AWS CLI using below command and provide AWS secret key, access key and region details
```bash
  aws configure
```

## Deployment

To deploy the AWS Services. Please run the below commands in sequence

```bash
terraform init
terraform import --var-file=config/deploy.tfvars aws_s3_bucket_public_access_block.gpo-ui gpo-ui
terraform plan --var-file=config\deploy.tfvars
terraform apply --var-file=config\deploy.tfvars
```

To destroy the AWS Services. Please run the below commands in sequence

```bash
terraform plan --var-file=config\destroy.tfvars
terraform apply --var-file=config\destroy.tfvars
terraform state rm aws_s3_bucket_public_access_block.gpo-ui
terraform destroy --var-file=config\destroy.tfvars
```