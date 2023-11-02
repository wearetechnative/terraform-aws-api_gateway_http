module "ssl_certificate" {
  source = "../../../modules/ssl_certificate/"

  providers = {
    aws = aws
    aws.acm_certificate_region = aws
  }

  name = var.name
  hosted_zone_id = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.name

  domain_name_configuration {
    certificate_arn = module.ssl_certificate.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [
    module.ssl_certificate # must validate before we can apply
  ]
}
