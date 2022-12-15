

output ecr_infos {
    value = [for d in data.aws_ecr_repository.ecr_infos : {"${d.id}": d.repository_url}]
}

output "lambda_info" {
    value = [for l in aws_lambda_function.lambdas : {"${l.function_name}": l.image_uri}]
}

output uuu {
    value = aws_lambda_function.lambdas[*]
}

output "logs" {
    value = aws_cloudwatch_log_group.log_group
}