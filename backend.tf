terraform {
  backend "s3" {
    bucket = "terraform-bioera"
    key    = "codepipeline/terraform_matchium.tfstate"
    region = "ap-south-1"
  }
} 