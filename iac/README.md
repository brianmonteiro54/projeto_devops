## Arquitetura

![](/iac/diagram/arquitetura.jpg)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.68.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.68.0 |

## Modules

No modules.


## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.domain_cert](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.domain_validation](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudtrail.cloudtrail_monitor](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/cloudtrail) | resource |
| [aws_db_instance.rds_api](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/db_subnet_group) | resource |
| [aws_ecr_lifecycle_policy.api_production_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_registry_scanning_configuration.api_production_scanning](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_ecr_repository.api_production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.api_production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.api_production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ecs_task_definition) | resource |
| [aws_eip.nat_eip_1](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/eip) | resource |
| [aws_eip.nat_eip_2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/eip) | resource |
| [aws_eip.vpn_production_eip](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/eip) | resource |
| [aws_eip_association.vpn_production_eip_association](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/eip_association) | resource |
| [aws_guardduty_detector.main](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_filter.iam_anomalies](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/guardduty_filter) | resource |
| [aws_iam_instance_profile.instance_profile_acesso_ssm2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.cloudwatchLogsPolicy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecsSecretsAccessPolicy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecsSecretManagerAndParameterStore](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecsTaskExecutionRole_TF](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role) | resource |
| [aws_iam_role.role_acesso_ssm2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatchLogsPolicyAttachment](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecsSecretsAccessPolicyAttachment](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecsTaskExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecsTaskExecutionRolePolicyGetSecretValue](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.vpn_production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/instance) | resource |
| [aws_internet_gateway.terraform_igw](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/internet_gateway) | resource |
| [aws_lb.production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ecs_api](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat_gateway_1](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat_gateway_2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/nat_gateway) | resource |
| [aws_route53_record.alb_record](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route53_record) | resource |
| [aws_route53_record.domain_validation_records](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route53_record) | resource |
| [aws_route53_record.vpn_record](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route53_record) | resource |
| [aws_route_table.private_route_table_1](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table) | resource |
| [aws_route_table.private_route_table_2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnet_1_association](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnet_2_association](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_1_association](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_2_association](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.auditoria-conta](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.cloudtrail_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.Pritunl_VPN](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_security_group.alb_production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_security_group.api-ecs](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_security_group.api_db](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_ssm_parameter.db_database](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db_port](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/ssm_parameter) | resource |
| [aws_subnet.private_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/subnet) | resource |
| [aws_vpc.terraform_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_security_group_egress_rule.egress_all_traffic](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_all_traffic_alb](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_all_traffic_ec2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_all_traffic_ecs](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_443_ec2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_5050_ec2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_80_ec2](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_alb_443](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_alb_80](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_ecs](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_ecs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rds_5432_alb](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rds_5432_ecs](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_wafv2_web_acl.production](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/wafv2_web_acl_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/region) | data source |
| [aws_route53_zone.domain_zone](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Certificado para o ACM | `string` | `"brian.pt"` | no |
| <a name="input_ecr_name"></a> [ecr\_name](#input\_ecr\_name) | Defini o nome do ecr | `string` | `"api-production"` | no |
| <a name="input_ecr_service_name"></a> [ecr\_service\_name](#input\_ecr\_service\_name) | Defini o nome do serviço ecs | `string` | `"api-production"` | no |
| <a name="input_ecs_cpu"></a> [ecs\_cpu](#input\_ecs\_cpu) | Defini quantidade de cpu do ecs | `string` | `"2048"` | no |
| <a name="input_ecs_memory"></a> [ecs\_memory](#input\_ecs\_memory) | Defini quantidade de memory do ecs | `string` | `"4096"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Nome da instance ec2 usada para vpn do Pritunl | `string` | `"Pritunl_VPN"` | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | Tamanho da instancia rds | `string` | `"db.t3.micro"` | no |
| <a name="input_tag_ambiente"></a> [tag\_ambiente](#input\_tag\_ambiente) | tags IAC | `string` | `"terraform"` | no |
| <a name="input_tag_prod"></a> [tag\_prod](#input\_tag\_prod) | tags de produção | `string` | `"production"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Defini o nome da vpc | `string` | `"production"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_production_uri"></a> [api\_production\_uri](#output\_api\_production\_uri) | url do ecr |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | Endpoint da RDS da API |
| <a name="output_secret_manager_arn"></a> [secret\_manager\_arn](#output\_secret\_manager\_arn) | Secret Manger |
