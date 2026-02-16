output "codepipeline_name" {
  value = aws_codepipeline.terraform_pipeline.name
}

output "codepipeline_arn" {
  value = aws_codepipeline.terraform_pipeline.arn
}

output "codebuild_project_name" {
  value = aws_codebuild_project.terraform_build.name
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.terraform_build.arn
} 