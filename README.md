<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

## [![Airwalk Consulting][logo]](https://airwalkconsulting.com) __Airwalk Consulting__

# terraform-aws-codebuild-deploy-tf

## Description

This AWS Teraform module sets up a CodeBuild/CodePipeline project that deploys a Terraform project from GitHub.

Just configure the variables with the github settings and an OAuth token giving it permissions to access the code.
You can also configure the required permissions that the CodeBuild/Pipeline roles require as you wish.

The `buildspec.yml` file in the source project can be used to match environment variables you set in this project (see Usage).

Current issues:
 * You need to change an environment variable to `terraform destroy...` a project
 * You must remember to `terraform destroy...` a project before destroying this project.
 * The examples shown are setup with projects running terraform using `var_file`s. Things could be adjusted to run terraform in any way you wish.
 * [BUG] Currently, obtaining the GitHub token from SSM flags up as a change on every TF run.


## Requirements

* Terraform 0.12.x (Although this project is written in Terraform 0.12, the pipeline it deploys can be used to deploy using ANY version of Terraform)
* A [github Oauth token](https://help.github.com/en/articles/git-automation-with-oauth-tokens) stored in AWS SSM Parameter Store
* A terraform project with an AWS CodeBuild `buildspec.yml` file in the root directory checked into GitHub


## Usage

```hcl
module "codebuild_tf_lambda_deploy" {
  source = "git::https://github.com/AirWalk-Digital/terraform-aws-codebuild-deploy-tf.git"

  region    = "eu-west-1"
  name      = "somename"
  namespace = "somenamespace"
  stage     = "dev"
  tags      = {
    Owner = "My Company"
  }

  github_owner                  = "github-User-Name"
  github_repo                   = "github_repo_name"
  git_branch                    = "branch_name"
  ssm_param_name_github_token   = "ssm/path_to/github_oath_token"
  codebuild_project_description = "An project that deploys a lambda"

  codebuild_iam_policy_arns = [
    "arn:aws:iam::aws:policy/AWSLambdaFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
  ]

  codepipeline_iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
  ]

  codebuild_env_vars = {
    {
      name  = "TF_VERSION"
      value = "0.11.14"
    },
    {
      name  = "TF_ENV"
      value = "account1_env_vars_file"
    },
    {
      name  = "TF_ACTION"
      value = "apply"
    },
    {
      name  = "TF_IN_AUTOMATION"
      value = "1"
    },
    {
      name  = "TF_LOG"
      value = "DEBUG"
    }
  ]
}
```

Also see [this example project](https://github.com/vishbhalla/terraform-aws-codebuild-deploy-tf-example).
It is setup to deploy [this example hello world Lambda Terraform project](https://github.com/vishbhalla/terraform-aws-hello-world-lambda).
Take particular note of [buildspec.yml](https://github.com/vishbhalla/terraform-aws-hello-world-lambda/blob/master/buildspec.yml) file
and how it ties in with the environment variables set here in `var.codebuild_env_vars`.

To trigger a build, check in some code into the branch `var.git_branch` or manually click the `Release Change` button on the AWS CodePipeline pipeline page.



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list(string) | `<list>` | no |
| codebuild_compute_type | CodeBuild compute type | string | `BUILD_GENERAL1_SMALL` | no |
| codebuild_env_vars | A map of env vars to set in CodeBuild | list(any) | `<list>` | no |
| codebuild_iam_policy_arns | IAM Policy to be attached to role | list(string) | `<list>` | no |
| codebuild_image | CodeBuild image | string | `aws/codebuild/standard:2.0` | no |
| codebuild_project_description | Description of CodeBuild project | string | `` | no |
| codebuild_type | CodeBuild image type | string | `LINUX_CONTAINER` | no |
| codepipeline_iam_policy_arns | IAM Policy to be attached to role | list(string) | `<list>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `environment`, etc. | string | `-` | no |
| git_branch | Git branch to build | string | `master` | no |
| github_owner | Github Repo owner/user | string | `` | no |
| github_repo | Github repo name | string | `` | no |
| name | Name (e.g. project name) | string | `` | no |
| namespace | Namespace | string | `` | no |
| region | region | string | `eu-west-1` | no |
| ssm_param_name_github_token | The SSM parameter store, parameter name which stores the github ouath token | string | `` | no |
| stage | Stage (e.g. environment) | string | `` | no |
| tags | Tags | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| codebuild_project_name | CodeBuild project name |
| codepipeline_pipeline_name | CodePipeline pipeline name |

## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen

```



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


  [logo]: https://pbs.twimg.com/profile_images/1049700314847293440/yMgqGf3w_bigger.jpg
