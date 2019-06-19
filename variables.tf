variable "terraform_state" {
  description = "Terraform backend state setup for S3"
  type        = "map"
  default     = {}
}

variable "region" {
  description = "region"
  type        = "string"
  default     = "eu-west-1"
}

variable "repo_name" {
  description = "Name of CodeCommit repository"
  type        = "string"
  default     = "repo"
}

variable "code_commit_username" {
  description = "IAM user name of CodeCommit user"
  type        = "string"
  default     = "code_commit_example_user"
}
