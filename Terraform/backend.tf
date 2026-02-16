terraform {
  backend "s3" {
    bucket         = "terraform-bioera"
    key            = "terraform/mathium.tfstate"
    region         = "ap-south-1"
  }
}