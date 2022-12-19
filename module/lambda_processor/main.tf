resource "aws_iam_role" "iam_for_lambda_processor" {
  name               = "iam_for_lambda_processor"
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

resource "aws_cloudwatch_log_group" "preprocess_log_group" {
    name = "/aws/lambda/${aws_lambda_function.lambda_preprocessor.function_name}"
    retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "postprocessor_log_group" {
    name = "/aws/lambda/${aws_lambda_function.lambda_postprocessor.function_name}"
    retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging_processor" {
  name        = "lambda_logging_processor"
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
  role       = aws_iam_role.iam_for_lambda_processor.name
  policy_arn = aws_iam_policy.lambda_logging_processor.arn
}


data "aws_ecr_repository" "ecr_infos_pre" {
    name = "preprocessor"
}

data "aws_ecr_repository" "ecr_infos_post" {
    name = "postprocessor"
}

resource "aws_lambda_function" "lambda_preprocessor" {
    function_name = "preprocessor"
    image_uri =  "${data.aws_ecr_repository.ecr_infos_pre.repository_url}:latest"
    architectures = ["x86_64"]
    package_type = "Image"


    role       = aws_iam_role.iam_for_lambda_processor.arn
    depends_on = [
        aws_iam_role_policy_attachment.lambda_logs, 
    ]
}

resource "aws_lambda_function" "lambda_postprocessor" {
    function_name = "postprocessor"
    image_uri =  "${data.aws_ecr_repository.ecr_infos_post.repository_url}:latest"
    architectures = ["x86_64"]
    package_type = "Image"


    role       = aws_iam_role.iam_for_lambda_processor.arn
    depends_on = [
        aws_iam_role_policy_attachment.lambda_logs, 
    ]
}