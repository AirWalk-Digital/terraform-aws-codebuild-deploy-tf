terraform_state = {
  bucket = "937405989913-codetools-play-tf-state"
  key    = "codetools/terraform.tfstate"
}

namespace = "example"
stage     = "dev"
name      = "hello-world"

tags      = {
  Owner = "Airwalk Consulting"
}
codebuild_project_description = "An example deploying a simple Hello World Python lambda"

github_owner = "vishbhalla"
github_repo  = "terraform-aws-hello-world-lambda"
