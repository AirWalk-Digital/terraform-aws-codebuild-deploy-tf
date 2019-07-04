provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"

  config = {
    bucket  = var.terraform_state["bucket"]
    region  = var.region
    key     = var.terraform_state["key"]
    encrypt = true
  }
}

data "aws_caller_identity" "current_account_id" {}

////////// CodeBuild Project

module "codebuild_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = ["codebuild", var.region]
  delimiter  = var.delimiter
  tags       = var.tags
}

resource "aws_s3_bucket" "artifcats" {
  bucket        = "${data.aws_caller_identity.current_account_id.account_id}${var.delimiter}${module.codebuild_label.id}"
  acl           = "private"
  force_destroy = "true"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid     = "TrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = module.codebuild_label.id
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  count      = length(var.codebuild_iam_policy_arns)
  role       = aws_iam_role.codebuild.name
  policy_arn = var.codebuild_iam_policy_arns[count.index]
}

resource "aws_codebuild_project" "codebuild" {
  name         = module.codebuild_label.id
  description  = var.codebuild_project_description
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_compute_type
    image        = var.codebuild_image
    type         = var.codebuild_type
    dynamic "environment_variable" {
      for_each = [for v in var.codebuild_env_vars: {
        name = v.name
        value = v.value
      }]
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

////////// CodePipeline Pipeline

module "codepipeline_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = ["codepipeline", var.region]
  delimiter  = var.delimiter
  tags       = var.tags
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid     = "TrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "codepipeline.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = module.codepipeline_label.id
  assume_role_policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  count      = length(var.codepipeline_iam_policy_arns)
  role       = aws_iam_role.codepipeline.name
  policy_arn = var.codepipeline_iam_policy_arns[count.index]
}

// Github OAuth token stored in SSM parameter store:
data "aws_ssm_parameter" "github_token" {
  name = var.ssm_param_name_github_token
}

resource "aws_codepipeline" "codepipeline" {
  name     = module.codepipeline_label.id
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifcats.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.git_branch
        OAuthToken = data.aws_ssm_parameter.github_token.value
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
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }
}
