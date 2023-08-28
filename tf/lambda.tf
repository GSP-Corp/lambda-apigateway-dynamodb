data "archive_file" "zip" {
  type        = "zip"
  source_file = "../lambda/hello.py"
  output_path = "../lambda/hello.zip"
}

resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  function_name = "${var.project_name}-staging"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.handler"
  runtime       = "python3.11"
  timeout       = 10
  # publish       = true
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "convert_log_group" {
  name = "/aws/lambda/${aws_lambda_function.hello.function_name}"
}