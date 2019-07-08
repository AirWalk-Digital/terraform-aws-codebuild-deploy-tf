output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.codebuild.name
}

output "codepipeline_pipeline_name" {
  description = "CodePipeline pipeline name"
  value       = aws_codepipeline.codepipeline.name
}
