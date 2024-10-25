data "aws_route53_zone" "hosted_zone" {
  zone_id = var.hosted_zone_id
  private_zone = false
}

resource "aws_route53_record" "this" {
  allow_overwrite = true

  name            = var.name
  type            = "A"
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}
