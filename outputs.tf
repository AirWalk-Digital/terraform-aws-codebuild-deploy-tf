output "codebuild_project_name" {
  description = "CodeBuild project name"
  #value       = join("", aws_codebuild_project.codebuild.*.name)
  value       = aws_codebuild_project.codebuild.name
}

output "codepipeline_pipeline_name" {
  description = "CodePipeline pipeline name"
  #value       = join("", aws_codepipeline.codepipeline.*.name)
  value       = aws_codepipeline.codepipeline.name
}
