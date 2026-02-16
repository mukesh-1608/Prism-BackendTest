resource "aws_iam_policy" "codepipeline_custom_policy" {
  name   = var.codepipeline_custom_policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
        "StringEqualsIfExists": {
          "iam:PassedToService": [
            "cloudformation.amazonaws.com",
            "elasticbeanstalk.amazonaws.com",
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    },
    {
      "Action": [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetRepository",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "elasticbeanstalk:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "cloudwatch:*",
        "s3:*",
        "sns:*",
        "cloudformation:*",
        "rds:*",
        "sqs:*",
        "ecs:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "lambda:InvokeFunction",
        "lambda:ListFunctions"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "opsworks:CreateDeployment",
        "opsworks:DescribeApps",
        "opsworks:DescribeCommands",
        "opsworks:DescribeDeployments",
        "opsworks:DescribeInstances",
        "opsworks:DescribeStacks",
        "opsworks:UpdateApp",
        "opsworks:UpdateStack"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeStacks",
        "cloudformation:UpdateStack",
        "cloudformation:CreateChangeSet",
        "cloudformation:DeleteChangeSet",
        "cloudformation:DescribeChangeSet",
        "cloudformation:ExecuteChangeSet",
        "cloudformation:SetStackPolicy",
        "cloudformation:ValidateTemplate"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuildBatches",
        "codebuild:StartBuildBatch"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "devicefarm:ListProjects",
        "devicefarm:ListDevicePools",
        "devicefarm:GetRun",
        "devicefarm:GetUpload",
        "devicefarm:CreateUpload",
        "devicefarm:ScheduleRun"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "servicecatalog:ListProvisioningArtifacts",
        "servicecatalog:CreateProvisioningArtifact",
        "servicecatalog:DescribeProvisioningArtifact",
        "servicecatalog:DeleteProvisioningArtifact",
        "servicecatalog:UpdateProduct"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:ValidateTemplate"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeImages"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "states:DescribeExecution",
        "states:DescribeStateMachine",
        "states:StartExecution"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "appconfig:StartDeployment",
        "appconfig:StopDeployment",
        "appconfig:GetDeployment"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:ap-south-1:891377374196:log-group:/aws/codepipeline/gpo",
        "arn:aws:logs:ap-south-1:891377374196:log-group:/aws/codepipeline/gpo:log-stream:*"
      ]
    }
  ]
}
EOF
} 

resource "aws_iam_role" "codepipeline_role" {
  name = var.codepipeline_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_custom_policy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_custom_policy.arn
}

  
resource "aws_iam_role" "codebuild_role" {
  name = var.codebuild_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "terraform_build" {
  name          = var.build_name
  description   = var.build_desc
  build_timeout = 20
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }
  }

  source {
    type            = "CODECOMMIT" # Change to GITHUB if needed
    location        = var.repo_url # Replace with your repo URL
    buildspec       = "Terraform/Terraform/buildspec.yml"
  }
}

resource "aws_codepipeline" "terraform_pipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "srm-codepipeline-artifacts" # Replace with your S3 bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit" # Change to GITHUB if needed
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = var.repo_name
        BranchName     = var.repo_branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform_build.name
      }
    }
  }
}

/*
resource "aws_cloudwatch_event_rule" "codecommit_push" {
  name        = var.trigger_name
  description = "Trigger pipeline on CodeCommit push"
  event_pattern = jsonencode({
    "source": ["aws.codecommit"],
    "resources": [
      "arn:aws:codecommit:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${var.repo_name}"
    ],
    "detail-type": ["CodeCommit Repository State Change"],
    "detail": {
      "event": ["referenceCreated", "referenceUpdated"],
      "referenceType": ["branch"],
      "referenceName": [var.repo_branch]
    }
  })
}

resource "aws_cloudwatch_event_target" "pipeline_target" {
  rule      = aws_cloudwatch_event_rule.codecommit_push.name
  target_id = "CodePipeline"
  arn       = aws_codepipeline.terraform_pipeline.arn
  role_arn  = aws_iam_role.eventbridge_codepipeline.arn
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eventbridge_codepipeline" {
  name = "eventbridge-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_codepipeline_policy" {
  name = "eventbridge-codepipeline-policy"
  role = aws_iam_role.eventbridge_codepipeline.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "codepipeline:StartPipelineExecution",
      Resource = aws_codepipeline.terraform_pipeline.arn
    }]
  })
}
*/
