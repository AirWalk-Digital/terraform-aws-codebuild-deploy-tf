provider "aws" {
  region  = "${var.region}"
}

data "terraform_remote_state" "state" {
  backend = "s3"

  config {
    bucket  = "${lookup(var.terraform_state, "bucket")}"
    region  = "${var.region}"
    key     = "${lookup(var.terraform_state, "key")}"
    encrypt = true
  }
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current_account_id" {}

////////// CodeBuild Project

resource "aws_s3_bucket" "artifcats" {
  bucket = "codeplay-${var.region}-${data.aws_caller_identity.current_account_id.account_id}"
  acl    = "private"
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    sid    = "TrustPolicy"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild_role" //var
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  count      = "${length(var.codebuild_iam_policy_arns)}"
  role       = "${aws_iam_role.codebuild_role.name}"
  policy_arn = "${var.codebuild_iam_policy_arns[count.index]}"
}

resource "aws_codebuild_project" "project" {
  name          = "hello_world_2" //var
  description   = "hello_world_2" //var
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "TF_VERSION" //var loop?
      value = "0.11.14"    //var
    }
    environment_variable {
      name  = "TF_ENV"   //var
      value = "sandbox3" //var
    }
  }
  source {
    type = "CODEPIPELINE"
  }
}

////////// CodePipeline Pipeline

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    sid    = "TrustPolicy"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "codepipeline.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline_role" //var
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attach" {
  count      = "${length(var.codepipeline_iam_policy_arns)}"
  role       = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "${var.codepipeline_iam_policy_arns[count.index]}"
}

// Github OAuth token stored in SSM parameter store:
data "aws_ssm_parameter" "github_token" {
  name = "github_ouath_token_codepipeline" //var
}

resource "aws_codepipeline" "codepipeline" {
  name = "hello_world_2" //var
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifcats.bucket}"
    type = "S3"
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
        Owner      = "vishbhalla" //var
        Repo       = "terraform-aws-hello-world-lambda" //var
        Branch     = "master" //var
        OAuthToken = "${data.aws_ssm_parameter.github_token.value}"
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
        ProjectName = "${aws_codebuild_project.project.name}"
      }
    }
  }
}
