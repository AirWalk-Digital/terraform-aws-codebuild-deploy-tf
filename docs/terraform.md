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

