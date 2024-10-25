resource "aws_apigatewayv2_integration" "cors" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"

  connection_id = aws_apigatewayv2_vpc_link.this.id
  connection_type = "VPC_LINK"

  # content_handling_strategy
  # credentials_arn 

  description = var.name

  integration_method = "OPTIONS" # because integration_type = "HTTP_PROXY"
  # integration_subtype

  integration_uri = var.lb_listener_arn

  # passthrough_behavior
  payload_format_version = "1.0"
  # request_parameters
  # request_templates

  # statuscode is still being fetched from the backend, correct here
  response_parameters {
    status_code = 405
    mappings = {
      "overwrite:statuscode": 204
    }
  }

  # template_selection_expression

  # timeout_milliseconds = 30000

  # no tls on backend
  # tls_config {
  #   server_name_to_verify = aws_route53_record.this.name
  # }
}

resource "aws_apigatewayv2_route" "cors" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "OPTIONS /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.cors.id}"

  depends_on = [
    aws_apigatewayv2_integration.cors, aws_apigatewayv2_vpc_link.this
  ]
}
