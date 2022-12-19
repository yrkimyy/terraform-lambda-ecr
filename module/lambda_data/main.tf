resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_cloudwatch_log_group" "log_group" {
    for_each      = toset(var.lambda_names)
    name = "/aws/lambda/${aws_lambda_function.lambdas[each.key].function_name}"
    retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


data "aws_ecr_repository" "data_ecr_infos" {
    for_each = toset(var.ecr_data_repos_names)
    name = each.key
}


resource "aws_lambda_function" "lambdas" {
    for_each      = toset(var.lambda_names)
    function_name = "${each.key}-lambda"

  //람다의 이름과 ecr_urls.name이 같으면 이걸 image_url로 사용하고 싶음. 
  //ecr_urls의 for문을 돌려서, name과 function_name을 비교한다. 
  //비교해서 같으면, ecr_urls[name]의 값을 image_url로 사용한다. 

    image_uri = "${lookup(data.aws_ecr_repository.data_ecr_infos, each.key, "No Match").repository_url}:latest"

    # image_uri = "166353092227.dkr.ecr.us-east-1.amazonaws.com/aaaa:latest"
    architectures = ["x86_64"]
    package_type = "Image"

    role       = aws_iam_role.iam_for_lambda.arn
    depends_on = [
        aws_iam_role_policy_attachment.lambda_logs, 
    ]
}

