output "apigatewayv2_id" {
    value = aws_apigatewayv2_api.this.id
}

output "apigatewayv2_api_endpoint" {
    value = aws_apigatewayv2_api.this.api_endpoint
}

output "apigatewayv2_arn" {
    value = aws_apigatewayv2_api.this.arn
}