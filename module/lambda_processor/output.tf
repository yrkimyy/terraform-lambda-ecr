
# output ecr_infos_pre {
#     value = [for d in data.aws_ecr_repository.ecr_infos_pre : {"${d.id}": d.repository_url}]
# }
# output ecr_infos_post {
#     value = [for d in data.aws_ecr_repository.ecr_infos_post : {"${d.id}": d.repository_url}]
# }

# output "lambda_info" {
#     value = [for l in aws_lambda_function.lambda_preprocessor : {"${l.function_name}": l.image_uri}]
# }

# output uuu {
#     value = aws_lambda_function.lambda_preprocessor[*]
# }

# output "logs" {
#     value = aws_cloudwatch_log_group.postprocessor_log_group
# }