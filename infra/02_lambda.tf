data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
        Sid    = "",
      },
    ],
  })

  inline_policy {
    name   = "lambda_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ec2:DescribeInstances",
            "ec2:CreateNetworkInterface",
            "ec2:AttachNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "autoscaling:CompleteLifecycleAction",
            "ec2:DeleteNetworkInterface"
          ],
          Resource = "*",
        },
      ],
    })
  }
}

resource "aws_security_group" "lambdas_sg" {
  vpc_id = aws_vpc.vpc.id
  name        = "lambda-security-group"
  description = "Allow lambda communication only in VPC"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Zip do arquivo .py
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./src/"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_ecommerceGetProducts" {

  function_name = "ecommerceGetProducts"
  role          = aws_iam_role.iam_for_lambda.arn
  description   = "Lamdba to return producs informations"
  handler       = "ecommerceGetProducts.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  filename      = "lambda_function_payload.zip"

   vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_group_ids = [aws_security_group.lambdas_sg.id]
  }

  tags = {
    Product = "ecommerce"
  }
}

resource "aws_lambda_function" "lambda_ecommercePostProducts" {

  function_name = "ecommercePostProducts"
  role          = aws_iam_role.iam_for_lambda.arn
  description   = "Lamdba to create a new product"
  handler       = "ecommercePostProducts.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  filename      = "lambda_function_payload.zip"

   vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_group_ids = [aws_security_group.lambdas_sg.id]
  }

  tags = {
    Product = "ecommerce"
  }
}

resource "aws_lambda_function" "lambda_ecommerceDeleteProducts" {

  function_name = "ecommerceDeleteProducts"
  role          = aws_iam_role.iam_for_lambda.arn
  description   = "Lamdba to delete a product"
  handler       = "ecommerceDeleteProducts.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  filename      = "lambda_function_payload.zip"

   vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_group_ids = [aws_security_group.lambdas_sg.id]
  }

  tags = {
    Product = "ecommerce"
  }
}
resource "aws_lambda_function" "lambda_ecommercePutProducts" {

  function_name = "ecommercePutProducts"
  role          = aws_iam_role.iam_for_lambda.arn
  description   = "Lamdba to delete a product"
  handler       = "ecommercePutProducts.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  filename      = "lambda_function_payload.zip"

   vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_group_ids = [aws_security_group.lambdas_sg.id]
  }

  tags = {
    Product = "ecommerce"
  }
}