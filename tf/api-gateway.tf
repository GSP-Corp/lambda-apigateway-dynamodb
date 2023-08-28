# API Gateway for my-lambda-project

resource "aws_apigatewayv2_api" "apigateway" {
  name          = "${var.project_name}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "apigateway_stage" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  name        = "staging"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "apigateway_integration" {
  api_id            = aws_apigatewayv2_api.apigateway.id
  integration_type  = "AWS_PROXY"
  integration_method = "POST"
  integration_uri   = aws_lambda_function.hello.invoke_arn
  payload_format_version = "2.0"
  passthrough_behavior = "WHEN_NO_MATCH"
  timeout_milliseconds = 3000
  connection_type = "INTERNET"
  description = "Integration for my-lambda-project"
}

resource "aws_apigatewayv2_route" "apigateway_route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.apigateway_integration.id}"
}