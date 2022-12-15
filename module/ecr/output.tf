output ecr_repos_urls {
    value = [for r in aws_ecr_repository.ecr_repos : {"${r.name}": r.repository_url}]
}

output ecr_repos_arns {
    value = [for r in aws_ecr_repository.ecr_repos : {"${r.name}": r.arn}]
}

output ecr_repos_registrys {
    value = [for r in aws_ecr_repository.ecr_repos : {"${r.name}": r.registry_id}]
}
