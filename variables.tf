variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket for CodePipeline artifacts."
  type        = string
}

variable "repo_name" {
  description = "Repository name for source stage."
  type        = string
}

variable "repo_branch" {
  description = "Branch name for source stage."
  type        = string
  default     = "main"
} 

variable "build_name" {
  description = "Code build name"
  type        = string
} 

variable "build_desc" {
  description = "Code build description"
  type        = string
} 

variable "repo_url" {
  description = "Code commit repository url"
  type        = string
} 

variable "codepipeline_name" {
  description = "Code pipeline name"
  type        = string
} 

variable "codepipeline_custom_policy" {
  description = "custom policy for code pipeline"
  type        = string
} 

variable "codepipeline_role_name" { 
  description = "IAM role name for CodePipeline"
  type        = string
} 


variable "codebuild_role_name" { 
  description = "Code Build role name"
  type        = string
} 

variable "terraform_state_file_name" { 
  description = "Name of the Terraform state file in S3"
  type        = string
} 




