resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  description = var.name
  protocol_type = "HTTP"
  # api_key_selection_expression

  ## quick create
  # credentials_arn
  # route_key
  # target
  # body , we use aws_apigatewayv2_integration & aws_apigatewayv2_route

  fail_on_warnings = true
  # route_selection_expression = "$request.method $request.path"
  disable_execute_api_endpoint = true

  cors_configuration {
    allow_credentials = false
    allow_headers = [ ]
    allow_methods = [ "GET", "POST" ]
    allow_origins = var.cors_origins
    expose_headers = [ ]
    max_age = 300
  }
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = var.name
  security_group_ids = var.security_groups
  subnet_ids         = var.subnets
}

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"

  connection_id = aws_apigatewayv2_vpc_link.this.id
  connection_type = "VPC_LINK"

  # content_handling_strategy
  # credentials_arn 

  description = var.name

  integration_method = "ANY" # because integration_type = "HTTP_PROXY"
  # integration_subtype

  integration_uri = var.lb_listener_arn

  # passthrough_behavior
  payload_format_version = "1.0"
  # request_parameters
  # request_templates
  # response_parameters
  # template_selection_expression

  # timeout_milliseconds = 30000

  # no tls on backend
  # tls_config {
  #   server_name_to_verify = aws_route53_record.this.name
  # }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = aws_apigatewayv2_stage.this.id
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "$default"
  description = "default"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn

    # chosen from default
    format = jsonencode({
      requestId: "$context.requestId"
      extendedRequestId:"$context.extendedRequestId"
      ip: "$context.identity.sourceIp"
      caller:"$context.identity.caller"
      user:"$context.identity.user"
      requestTime:"$context.requestTime"
      httpMethod:"$context.httpMethod"
      resourcePath:"$context.resourcePath"
      status:"$context.status"
      protocol: "$context.protocol"
      responseLength: "$context.responseLength"
    })
  }

  auto_deploy = true

  # client_certificate_id
  # default_route_settings
  # deployment_id
  # route_settings
  # stage_variables

  default_route_settings {
    detailed_metrics_enabled = true

    # defaults to 0 if not set properly causing 429 errors
    throttling_burst_limit = 2000
    throttling_rate_limit = 1000
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/api_gw/${var.name}/default/"
  retention_in_days = 90
  kms_key_id = var.kms_key_arn
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$default" # "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"

  depends_on = [
    aws_apigatewayv2_integration.this, aws_apigatewayv2_vpc_link.this
  ]
}
