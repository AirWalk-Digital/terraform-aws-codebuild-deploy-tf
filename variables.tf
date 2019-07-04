variable "terraform_state" {
  description = "Terraform backend state setup for S3"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-west-1"
}

variable "namespace" {
  description = "Namespace"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name (e.g. project name)"
  type        = string
  default     = ""
}

variable "stage" {
  description = "Stage (e.g. environment)"
  type        = string
  default     = ""
}

variable "attributes" {
  description = "Additional attributes (e.g. `policy` or `role`)"
  type        = list(string)
  default     = []
}

variable "delimiter" {
  description = "Delimiter to be used between `name`, `namespace`, `environment`, etc."
  type        = string
  default     = "-"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

variable "codebuild_project_description" {
  description = "Description of CodeBuild project"
  type        = string
  default     = ""
}

variable "codebuild_iam_policy_arns" {
  description = "IAM Policy to be attached to role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AWSLambdaFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
  ]
}

variable "codepipeline_iam_policy_arns" {
  description = "IAM Policy to be attached to role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess",
  ]
}

variable "codebuild_env_vars" {
  description = "A map of env vars to set in CodeBuild"
  #type        = object({ name=string, value=number })
  type        = list(any)
  default = [
    {
      name  = "TF_VERSION"
      value = "0.12.3"
    },
    {
      name  = "TF_ENV"
      value = "sandbox3"
    },
    {
      name  = "TF_ACTION"
      value = "apply"
      #value = "destroy"
    },
    {
      name  = "TF_IN_AUTOMATION"
      value = "1"
    },
    {
      name  = "TF_LOG"
      value = "DEBUG"  # Available options: TRACE, DEBUG, INFO, WARN or ERROR
    }
  ]
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild image"
  type        = string
  default     = "aws/codebuild/standard:2.0"
}

variable "codebuild_type" {
  description = "CodeBuild image type"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "github_owner" {
  description = "Github Repo owner/user"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "Github repo name"
  type        = string
  default     = ""
}

variable "git_branch" {
  description = "Git branch to build"
  type        = string
  default     = "master"
}

variable "ssm_param_name_github_token" {
  description = "The SSM parameter store, parameter name which stores the github ouath token"
  type        = string
  default     = "github_ouath_token_codepipeline"
}

