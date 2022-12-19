
resource "aws_ecr_repository" "ecr_repos" {
    for_each = toset(var.ecr_repos_names)
    name = each.key

    image_scanning_configuration {
      scan_on_push = false
    }
}


resource "null_resource" "ecr_image" {
  for_each = toset(var.ecr_repos_names)

  triggers = {
    sample_file = md5(file("../../lambda_functions/pacman.js"))
    docker_file = md5(file("../../lambda_functions/Dockerfile"))
  }

  provisioner "local-exec" {
    command = <<EOF
           aws ecr get-login-password --region us-east-1 --profile=yrkimyy | docker login --username AWS --password-stdin 166353092227.dkr.ecr.us-east-1.amazonaws.com
           docker build -t ${aws_ecr_repository.ecr_repos[each.key].repository_url}:latest .
           docker push ${aws_ecr_repository.ecr_repos[each.key].repository_url}:latest
       EOF

    interpreter = ["bash", "-c"] # For Linux/MacOS
    working_dir = "../../lambda_functions"
  }
}