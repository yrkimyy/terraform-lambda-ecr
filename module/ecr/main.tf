resource "aws_ecr_repository" "ecr_repos" {
    for_each = toset(var.ecr_repos_names)
    name = each.key

    image_scanning_configuration {
      scan_on_push = false
    }
}
