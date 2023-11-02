> START INSTRUCTION FOR TECHNATIVE ENGINEERS

# terraform-aws-module-template

Template for creating a new TerraForm AWS Module. For TechNative Engineers.

## Instructions

### Your Module Name

Think hard and come up with the shortest descriptive name for your module.
Look at competition in the [terraform
registry](https://registry.terraform.io/).

Your module name should be max. three words seperated by dashes. E.g.

- html-form-action
- new-account-notifier
- budget-alarms
- fix-missing-tags

### Setup Github Project

1. Click the template button on the top right...
1. Name github project `terraform-aws-[your-module-name]`
1. Make project private untill ready for publication
1. Add a description in the `About` section (top right)
1. Add tags: `terraform`, `terraform-module`, `aws` and more tags relevant to your project: e.g. `s3`, `lambda`, `sso`, etc..
1. Install `pre-commit`

### Develop your module

1. Develop your module
1. Try to use the [best practices for TerraForm
   development](https://www.terraform-best-practices.com/) and [TerraForm AWS
   Development](https://github.com/ozbillwang/terraform-best-practices).

## Finish project documentation

1. Set well written title
2. Add one or more shields
3. Start readme with a short and complete as possible module description. This
   is the part where you sell your module.
4. Complete README with well written documentation. Try to think as a someone
   with three months of Terraform experience.
5. Check if pre-commit correctly generates the standard Terraform documentation.

## Publish module

If your module is in a state that it could be useful for others and ready for
publication, you can publish a first version.

1. Create a [Github
   Release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
2. Publish in the TerraForm Registry under the Technative Namespace (the GitHub
   Repo must be in the TechNative Organization)

---

> END INSTRUCTION FOR TECHNATIVE ENGINEERS


# Terraform AWS [API Gateway HTTP] ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

<!-- SHIELDS -->

API Gateway module to handle HTTP requests. Mostly used to handle CORS in the infrastructure for services behind an ALB using ECS/EKS.

[![](we-are-technative.png)](https://www.technative.nl)

***Beware***: Make sure you don't enable strict `desync_mitigation_mode` on the ALB otherwise the vpc link integration will not work.

This module needs to be split as its currently too opinionated:
- Terminates SSL to HTTP (non-SSL) lb listener
- Creates Route53 and SSL certificates
- Only handles HTTP_PROXY to other HTTP servers

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

...

## Usage

To use this module ...

```hcl
module "api_gw" {

  source = "git@github.com:wearetechnative/terraform-aws-api_gateway_http?ref=HEAD" 

  name            = "some_api"
  subnets         = var.private_subnet_ids
  security_groups = [ aws_security_group.example.id ]
  lb_listener_arn = aws_alb.http_listener.arn
  hosted_zone_id  = data.aws_route53_zone.dev_environment.zone_id
  kms_key_arn     = aws_kms_key.a.key_arn
  cors_origins    = [ "https://www.acne.com"]
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ssl_certificate"></a> [ssl\_certificate](#module\_ssl\_certificate) | ../../../modules/ssl_certificate/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.cors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.cors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_apigatewayv2_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors_origins"></a> [cors\_origins](#input\_cors\_origins) | List of CORS origins allowed. | `list(string)` | `[]` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Hosted zone ID is always required to properly link the application to the load balancer. | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key to use for encrypting CloudWatch log groups. | `string` | n/a | yes |
| <a name="input_lb_listener_arn"></a> [lb\_listener\_arn](#input\_lb\_listener\_arn) | Load balancer listener ARN. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Prefix name for DynamoDB. Must be unique within the region. | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security groups to assign. Inbound ports will be added by the module. | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Public subnets with an internet gateway for LB traffic. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigatewayv2_api_endpoint"></a> [apigatewayv2\_api\_endpoint](#output\_apigatewayv2\_api\_endpoint) | n/a |
| <a name="output_apigatewayv2_arn"></a> [apigatewayv2\_arn](#output\_apigatewayv2\_arn) | n/a |
| <a name="output_apigatewayv2_id"></a> [apigatewayv2\_id](#output\_apigatewayv2\_id) | n/a |
<!-- END_TF_DOCS -->
