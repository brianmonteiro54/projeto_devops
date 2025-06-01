## Arquitetura

![](/infra/diagram/arquitetura.jpg)

## Recursos

Este projeto provisiona os seguintes recursos na AWS:

- **ACM**: Certificado SSL
- **CloudTrail**: Monitoramento de eventos, com logs armazenados em bucket S3 específico
- **RDS**: Banco de Dados PostgreSQL com Multi-AZ e criptografia
- **ECR**: Registro de imagens Docker com **scan_on_push** ativado
- **ECS**: Cluster para execução de containers
- **S3**: Buckets para logs de auditoria do **CloudTrail** e armazenamento do **tfstate**
- **GuardDuty**: Análise de anomalias de IAM
- **IAM Roles e Policies**: Perfis de acesso configurados para os serviços EC2, ECS, Secrets Manager e Parameter Store, com políticas detalhadas para cada um:
  - **Role para EC2**: Permite que instâncias EC2 utilizem o AWS Systems Manager (SSM) para gerenciamento, com a política `AmazonSSMManagedInstanceCore` anexada.
  - **Role para ECS Task Execution**: Permite que as tarefas ECS assumam permissões necessárias para executar containers e registrar logs no CloudWatch.
  - **Role para Secrets Manager e Parameter Store**: Permite que tarefas ECS acessem segredos específicos no Secrets Manager e parâmetros no SSM, garantindo segurança no acesso aos recursos sensíveis.
- **Load Balancer**: Distribuição de tráfego para containers
- **WAF**: Firewall para proteção da aplicação, com as seguintes regras:
  - Regra 1: Proteção para áreas administrativas
  - Regra 2: Proteção contra IPs maliciosos conhecidos
  - Regra 3: Proteção contra IPs anônimos (proxies, VPNs, etc.)
  - Regra 4: Conjunto de regras comuns para proteção geral
  - Regra 5: Bloqueia entradas de dados conhecidamente maliciosos
  - Regra 6: Proteção contra injeção SQL no GuardDuty
  - Regra 7: Criar um filtro para anomalias de IAM no GuardDuty
- **Route53**: Gerenciamento de registros DNS (não cria a zona hospedada, apenas os registros necessários para ACM, Load Balancer e EC2)
- **Sub-redes e tabelas de rotas**: Para isolamento da infraestrutura
- **Endpoints para VPC**: Integração com serviços AWS, incluindo **ECR**, **ECS**
- **NAT Gateway**: Gateway para saída de tráfego da VPC
- **Internet Gateway**: Gateway que permite a conectividade entre a VPC e a internet pública.
- **Parameter Store**: Armazena o nome do banco de dados, endpoint do RDS e porta do banco de dados
- **Secret Manager**: Armazena o username e password do banco de dados
- **EC2**: Instância para VPN usando Pritunl

## Passo-a-Passo para Provisionamento

Siga as instruções abaixo para provisionar a infraestrutura usando Terraform. Este projeto utiliza **OpenID Connect (OIDC)** para autenticação com a AWS via GitHub Actions, o que elimina a necessidade de configurar chaves de acesso estáticas para provisionamento em ambientes de CI/CD. Para desenvolvimento e execução local, utilize o AWS CLI.



1.  **Clonar o repositório:**

    ```bash
    git clone https://github.com/brianmonteiro54/projeto_devops.git
    cd projeto_devops/infra
    ```

2.  **Configuração de Autenticação AWS:**

    * **Via GitHub Actions:**
        Os workflows do GitHub Actions (definidos em `.github/workflows/terraform-*.deployment.yml`) utilizam OIDC para autenticar na AWS. Uma Role IAM na AWS é assumida dinamicamente durante a execução do workflow, utilizando os segredos `AWS_ASSUME_ROLE_ARN` (para o ARN da role) e `AWS_REGION` (para a região AWS). Este método é mais seguro, pois não armazena credenciais de longa duração.


    * **Para Execução Manual (Local):**
        Siga as instruções para fornecer seu Access Key ID, Secret Access Key, região padrão e formato de saída. Isso configurará o perfil `default` ou permitirá que você especifique um perfil nomeado.
        Certifique-se de que o usuário ou perfil IAM configurado possua as permissões necessárias para provisionar os recursos AWS definidos no Terraform.
        
        ```bash
        aws configure
        # Siga as instruções para fornecer Access Key ID, Secret Access Key, região e formato de saída.
        # Ou, para um perfil nomeado:
        # aws configure --profile brian
        ```
        

3.  **Configuração do Backend do Terraform:**
    O arquivo `backend.tf` apresenta uma configuração minimalista do backend S3 (`backend "s3" {}`). Essa abordagem é proposital, pois o bucket S3 utilizado para armazenar o arquivo `tfstate` é definido dinamicamente pelos workflows do GitHub Actions, por meio da variável `aws-statefile-s3-bucket` (exemplo: `"brian-terraform"`).

- **Execução via GitHub Actions (Automatizada):**  
  O bucket configurado no workflow do GitHub Actions será automaticamente utilizado para armazenamento do estado do Terraform durante a execução da pipeline.

- **Execução Manual (Local):**  
  Para rodar o Terraform localmente utilizando um bucket específico para o `tfstate`, recomenda-se modificar diretamente o arquivo `backend.tf` para incluir o nome desejado do bucket.

        ```hcl
        # infra/backend.tf
        terraform {
          backend "s3" {
            bucket  = "meu-bucket-tfstate-personalizado" # Altere este nome para o seu bucket S3
            key     = "infra/terraform.tfstate"
            region  = "us-east-1"                       # Defina sua região
            # profile = "brian" # Opcional: Se você estiver usando um perfil AWS nomeado diferente do default
          }
        }
        ```

4.  **Seleção do Ambiente (`tfvars`):**
    Este projeto utiliza arquivos `.tfvars` para gerenciar variáveis de ambiente específicas (desenvolvimento e produção). `-var-file`** para aplicar as variáveis do ambiente desejado diretamente:

    * **Para ambiente de Desenvolvimento:**
        ```bash
        terraform plan -var-file="envs/dev/terraform.tfvars"
        # ou para aplicar
        terraform apply -var-file="envs/dev/terraform.tfvars"
        ```
    * **Para ambiente de Produção:**
        ```bash
        terraform plan -var-file="envs/prod/terraform.tfvars"
        # ou para aplicar
        terraform apply -var-file="envs/prod/terraform.tfvars"
        ```
    > **Importante:** Os workflows do GitHub Actions já configuram o `-var-file` apropriado para cada ambiente automaticamente.

5.  **Controle de Destruição (`destroy_config.json`):**
    O arquivo `infra/destroy_config.json` na raiz da pasta `infra` controla se o Terraform deve executar um `destroy` ou um `apply` quando acionado via pipeline.

    ```json
    {
      "dev": true,
      "prod": true
    }
    ```
    * Quando configurado como `true` para um determinado ambiente, o workflow Terraform correspondente (`terraform-develop.deployment.yml` ou `terraform-production.deployment.yml`) gera a saída `destroy_active: true`.

    * A condição `if: needs.terraform_dev.outputs.destroy_active == 'false'` (ou equivalente para produção) presente nos workflows de deploy da aplicação assegura que o deploy será realizado somente quando a infraestrutura não estiver em processo de destruição.

    * Para aplicar alterações na infraestrutura, é necessário que o valor do ambiente desejado esteja definido como `false` no arquivo `destroy_config.json`. Para acionar a destruição da infraestrutura, o valor deve ser alterado para `true`.

6.  **Inicializar o Terraform:**
    Este comando inicializa um novo diretório de trabalho do Terraform, baixando os provedores necessários e configurando o backend.

    ```bash
    terraform init
    ```

7.  **Verificar o plano de execução:**
    Gere um plano de execução para visualizar os recursos que serão criados, modificados ou destruídos. Lembre-se de incluir o `-var-file` se estiver rodando localmente.

    ```bash
    terraform plan -var-file="envs/dev/terraform.tfvars" # Exemplo para ambiente de dev
    ```
    Este comando mostrará o que será provisionado e os detalhes de cada recurso.

8.  **Aplicar o plano:**
    Execute o plano para provisionar os recursos na AWS. Lembre-se de incluir o `-var-file` se estiver rodando localmente.

    ```bash
    terraform apply -var-file="envs/dev/terraform.tfvars" # Exemplo para ambiente de dev
    ```
    Digite `yes` para confirmar e aplicar o plano. O Terraform então criará os recursos listados acima.

---

## Fluxos de Trabalho CI/CD com GitHub Actions

Este projeto utiliza GitHub Actions para automatizar o provisionamento da infraestrutura e o deploy de aplicações em diferentes ambientes. A autenticação na AWS é realizada de forma segura via OpenID Connect (OIDC), eliminando a necessidade de credenciais estáticas.

* **`terraform-production.deployment.yml`**:
    * **Disparo**: `push` para o branch `main` ou `repository_dispatch` com `deploy-production` type.
    * **Funcionalidade**: Executa o workflow `terraform.yml` (`v1.5` do template `devops-template`) para provisionar a infraestrutura de produção.
        * O bucket do `tfstate` (`brian-terraform`) é passado para o workflow via `aws-statefile-s3-bucket`.
        * A autenticação AWS é gerenciada pelos segredos `AWS_ASSUME_ROLE_ARN` e `AWS_REGION`, que são usados pelo OIDC para assumir uma role IAM com as permissões necessárias.
        * O workflow também avalia o `destroy_config.json` para determinar se deve executar um `terraform apply` ou `terraform destroy`.
    * **Deploy da Aplicação**: Após o provisionamento bem-sucedido da infraestrutura (e somente se o output `destroy_active` do job `terraform_production` for `false`), o workflow `bundle.yml` é acionado para o deploy da aplicação no ECS do ambiente de produção.

* **`terraform-develop.deployment.yml`**:
    * **Disparo**: `push` para o branch `develop` ou `repository_dispatch` com `deploy-development` type.
    * **Funcionalidade**: Executa o workflow `terraform.yml` (`v1.5` do template `devops-template`) para provisionar a infraestrutura de desenvolvimento.
        * O bucket do `tfstate` (`brian-terraform`) é passado para o workflow via `aws-statefile-s3-bucket`.
        * A autenticação AWS é gerenciada pelos segredos `AWS_ASSUME_ROLE_ARN` e `AWS_REGION`, que são usados pelo OIDC para assumir uma role IAM com as permissões necessárias.
        * O workflow também avalia o `destroy_config.json` para determinar se deve executar um `terraform apply` ou `terraform destroy`.
    * **Deploy da Aplicação**: Após o provisionamento bem-sucedido da infraestrutura (e somente se o output `destroy_active` do job `terraform_dev` for `false`), o workflow `bundle.yml` é acionado para o deploy da aplicação no ECS do ambiente de desenvolvimento.

Esses fluxos de trabalho garantem que a infraestrutura seja provisionada e gerenciada de forma consistente, segura e automatizada, utilizando as melhores práticas de IaC e CI/CD.

## Custos Estimados da Infraestrutura AWS — Ambiente de Produção

Este projeto utiliza o [Infracost](https://www.infracost.io/) para estimar os custos mensais da infraestrutura provisionada via Terraform, facilitando a transparência financeira e o controle orçamentário.

### Resumo do Custo Mensal Estimado (Maio 2025)

| Serviço / Recurso                   | Custo Mensal Estimado (USD) |
|-----------------------------------|-----------------------------:|
| **ECS Service (CPU & Memória)**   | $144.16                      |
| **NAT Gateway (2 unidades)**       | $65.70                       |
| **RDS Multi-AZ (db.t3.micro)**    | $30.88                       |
| **Application Load Balancer (ALB)** | $16.43                      |
| **Instância EC2 VPN (t4g.micro)** | $6.93                        |
| **VPC Endpoints (ECR, ECS, etc.)** | $43.80                      |
| **WAF (Web ACL)**                 | $5.00                        |
| **Outros Recursos e Uso Variável** | —                           |
| **Total Aproximado**              | **$312.90**                  |

> Estes valores são baseados em estimativas de uso médio mensal e refletem o custo esperado para o ambiente de produção.

### Relatório Completo de Custos

O relatório detalhado, gerado automaticamente via Infracost, está disponível no arquivo [`report.html`](https://edn.0p.pt/terraform/report.html). Ele inclui a análise granular de cada recurso e suas componentes de custo, além de custos dependentes de uso.

## Considerações sobre VPN (Pritunl)

A instância EC2 configurada com Pritunl está sendo usada como VPN para a arquitetura. Atualmente, este projeto contempla apenas o ambiente de produção. No entanto, em um ambiente de uma empresa real, é recomendável ter os ambientes de **produção** e **staging** separados. A VPN foi criada para fornecer acesso seguro ao ambiente de **staging**, que não seria aberto à internet pública. Dessa forma, qualquer teste da aplicação seria feito com segurança antes de ser lançado no ambiente de produção.
## Requisitos

| Nome      | Versão  |
|-----------|---------|
| terraform | >= 1.12.0 |
| aws       | 5.98.0  |

## Providers

| Nome | Versão |
|------|--------|
| aws  | 5.98.0 |

## Modules

No modules.


## Recursos

| Nome                                          | Tipo     |
|-----------------------------------------------|----------|
| aws_acm_certificate.domain_cert                | resource |
| aws_acm_certificate_validation.domain_validation | resource |
| aws_appautoscaling_policy.scale_down_policy    | resource |
| aws_appautoscaling_policy.scale_up_policy      | resource |
| aws_appautoscaling_target.ecs_service           | resource |
| aws_cloudtrail.cloudtrail_monitor               | resource |
| aws_cloudwatch_metric_alarm.cpu_high             | resource |
| aws_cloudwatch_metric_alarm.cpu_low              | resource |
| aws_cloudwatch_metric_alarm.scale_down_alarm     | resource |
| aws_cloudwatch_metric_alarm.scale_up_alarm       | resource |
| aws_db_instance.rds                              | resource |
| aws_db_subnet_group.rds_subnet_group             | resource |
| aws_ecr_lifecycle_policy.app_ecr_lifecycle       | resource |
| aws_ecr_registry_scanning_configuration.app_ecr_scanning | resource |
| aws_ecr_repository.app_ecr                       | resource |
| aws_ecs_cluster.cluster                          | resource |
| aws_ecs_service.ecs_name                         | resource |
| aws_ecs_task_definition.task_definition          | resource |
| aws_eip.nat_eip_1                               | resource |
| aws_eip.nat_eip_2                               | resource |
| aws_eip.vpn_ec2_eip                             | resource |
| aws_eip_association.vpn_ec2_eip_association     | resource |
| aws_guardduty_detector.main                      | resource |
| aws_guardduty_filter.iam_anomalies               | resource |
| aws_iam_instance_profile.instance_profile_acesso_ssm2 | resource |
| aws_iam_policy.cloudwatchLogsPolicy               | resource |
| aws_iam_policy.ecsSecretsAccessPolicy              | resource |
| aws_iam_role.ecsSecretManagerAndParameterStore     | resource |
| aws_iam_role.ecsTaskExecutionRole_TF               | resource |
| aws_iam_role.role_acesso_ssm2                       | resource |
| aws_iam_role_policy_attachment.cloudwatchLogsPolicyAttachment | resource |
| aws_iam_role_policy_attachment.ecsSecretsAccessPolicyAttachment | resource |
| aws_iam_role_policy_attachment.ecsTaskExecutionRolePolicy | resource |
| aws_iam_role_policy_attachment.ecsTaskExecutionRolePolicyGetSecretValue | resource |
| aws_iam_role_policy_attachment.ssm_managed_policy  | resource |
| aws_instance.vpn_ec2                              | resource |
| aws_internet_gateway.terraform_igw               | resource |
| aws_lb.alb                                       | resource |
| aws_lb_listener.http                             | resource |
| aws_lb_listener.https                            | resource |
| aws_lb_target_group.ecs_api                       | resource |
| aws_nat_gateway.nat_gateway_1                     | resource |
| aws_nat_gateway.nat_gateway_2                     | resource |
| aws_route53_record.alb_record                      | resource |
| aws_route53_record.domain_validation_records      | resource |
| aws_route53_record.vpn_record                      | resource |
| aws_route_table.private_route_table_1              | resource |
| aws_route_table.private_route_table_2              | resource |
| aws_route_table.public_route_table                  | resource |
| aws_route_table_association.private_subnet_1_association | resource |
| aws_route_table_association.private_subnet_2_association | resource |
| aws_route_table_association.public_subnet_1_association | resource |
| aws_route_table_association.public_subnet_2_association | resource |
| aws_s3_bucket.auditoria-conta                       | resource |
| aws_s3_bucket_policy.cloudtrail_bucket_policy        | resource |
| aws_security_group.Pritunl_VPN                        | resource |
| aws_security_group.alb                               | resource |
| aws_security_group.ecs-sg                            | resource |
| aws_security_group.rds_db                            | resource |
| aws_ssm_parameter.db_database                         | resource |
| aws_ssm_parameter.db_endpoint                         | resource |
| aws_ssm_parameter.db_port                             | resource |
| aws_subnet.private_subnet_1                           | resource |
| aws_subnet.private_subnet_2                           | resource |
| aws_subnet.public_subnet_1                            | resource |
| aws_subnet.public_subnet_2                            | resource |
| aws_vpc.terraform_vpc                                 | resource |
| aws_vpc_endpoint.ecr_api                              | resource |
| aws_vpc_endpoint.ecr_dkr                              | resource |
| aws_vpc_endpoint.ecs                                  | resource |
| aws_vpc_endpoint.secretsmanager                       | resource |
| aws_vpc_endpoint.ssm                                  | resource |
| aws_vpc_endpoint.ssm_messages                         | resource |
| aws_vpc_security_group_egress_rule.egress_all_traffic | resource |
| aws_vpc_security_group_egress_rule.egress_all_traffic_alb | resource |
| aws_vpc_security_group_egress_rule.egress_all_traffic_ec2 | resource |
| aws_vpc_security_group_egress_rule.egress_all_traffic_ecs | resource |
| aws_vpc_security_group_ingress_rule.ingress_443_ec2  | resource |
| aws_vpc_security_group_ingress_rule.ingress_5050_ec2 | resource |
| aws_vpc_security_group_ingress_rule.ingress_80_ec2   | resource |
| aws_vpc_security_group_ingress_rule.ingress_alb_443  | resource |
| aws_vpc_security_group_ingress_rule.ingress_alb_80   | resource |
| aws_vpc_security_group_ingress_rule.ingress_ecs      | resource |
| aws_vpc_security_group_ingress_rule.ingress_ecs_endpoint | resource |
| aws_vpc_security_group_ingress_rule.ingress_rds_5432_alb | resource |
| aws_vpc_security_group_ingress_rule.ingress_rds_5432_ecs | resource |

## Inputs e valores para produção

| Nome                   | Descrição                                        | Tipo           | Valor atual de produção                              |
|------------------------|-------------------------------------------------|----------------|-----------------------------------------------------|
| instance_name          | Nome da instance ec2 usada para vpn do Pritunl  | string         | "Pritunl_VPN_prod"                                  |
| tag_environment        | tags do ambiente                                 | string         | "production"                                        |
| tag_ambiente           | tags IAC                                         | string         | "terraform-prod"                                    |
| vpc_name               | Defini o nome da vpc                             | string         | "production"                                        |
| vpc_cidr_block         | CIDR da VPC                                     | string         | "172.80.0.0/16"                                    |
| public_subnet_cidrs    | CIDRs das subnets públicas (2)                   | list(string)   | ["172.80.1.0/24", "172.80.2.0/24"]                 |
| private_subnet_cidrs   | CIDRs das subnets privadas (2)                    | list(string)   | ["172.80.3.0/24", "172.80.4.0/24"]                 |
| availability_zones     | Zonas de disponibilidade para as subnets         | list(string)   | ["us-east-1a", "us-east-1b"]                        |
| ecr_name               | Defini o nome do ecr                             | string         | "api-production"                                   |
| ecr_service_name       | Defini o nome do serviço ecs                     | string         | "api-production"                                   |
| ecs_cpu                | Defini quantidade de cpu do ecs                  | string         | "2048"                                             |
| ecs_memory             | Defini quantidade de memory do ecs               | string         | "4096"                                             |
| domain_name            | Certificado para o ACM                           | string         | "brian.pt"                                         |
| rds_instance_type      | Tamanho da instancia rds                         | string         | "db.t4g.small"                                     |
| cloudtrail_name        | Nome do CloudTrail para o ambiente               | string         | "cloudtrail-monitor-prod"                          |
| cloudtrail_s3_bucket_prefix | Prefixo do bucket S3 para o CloudTrail         | string         | "cloudtrail-auditoria-prod"                        |
| cloudtrail_s3_key_prefix | Prefixo da chave dentro do bucket S3 para armazenar logs do CloudTrail | string         | "prod"                                             |
| create_cloudtrail    | Flag para controlar a criação do CloudTrail. Defina como true para criar o CloudTrail | bool         | true                                                |
| iam_role_name          | Nome da IAM Role para EC2                        | string         | "role-acesso-ssm2-prod"                            |
| instance_profile_name  | Nome do Instance Profile associado à Role        | string         | "instance-profile-acesso-ssm2-prod"                |
| ami_id                 | AMI ID da instância EC2 para VPN                 | string         | "ami-096ea6a12ea24a797"                           |
| instance_type          | Tipo da instância EC2                            | string         | "t4g.micro"                                        |
| ecs_cluster_name       | Nome do cluster ECS para o ambiente               | string         | "production"                                       |
| ecs_service_name       | Nome do serviço ECS                              | string         | "api-production"                                   |
| ecs_desired_count      | Quantidade desejada de instâncias(taks) do serviço ECS | number         | 2                                                  |
| container_name         | Nome do container para o serviço ECS             | string         | "api-production"                                   |
| container_port         | Porta do container para o serviço ECS            | number         | 3000                                               |
| alb_name               | Nome do Application Load Balancer                | string         | "production"                                       |
| alb_target_group_name  | Nome do target group do ALB                       | string         | "ecs-api"                                          |
| rds_engine             | Engine do RDS                                   | string         | "postgres"                                         |
| rds_engine_version     | Version do engine do RDS                         | string         | "16.3"                                             |
| rds_parameter_group    | Grupo de parâmetros do RDS                       | string         | "default.postgres16"                               |
| rds_db_name            | Nome do banco de dados                           | string         | "api"                                              |
| rds_identifier         | Identificador único da instância RDS             | string         | "api-production"                                   |
| rds_multi-az           | Instância RDS com alta disponibilidade (Multi-AZ) | bool           | true                                               |
| rds_delete_automated_backups | Backup automático excluído com instância       | bool           | false                                              |
| rds_username           | Nome do usuário do RDS                           | string         | "postgres"                                         |
| rds_backup_retention_period | Período de retenção dos backups automáticos (dias) | number         | 7                                                  |
| waf_acl_name           | Nome do Web ACL (WAF)                            | string         | "waf-production"                                   |
| waf_description        | Descrição do Web ACL                             | string         | "Web ACL para ambiente de prod"                    |
| waf_metric_name        | Nome da métrica do Web ACL para o CloudWatch     | string         | "waf-prod-metric"                                  |
| ecs_max_capacity       | Capacidade máxima do serviço ECS                 | number         | 10                                                 |
| ecs_min_capacity       | Capacidade mínima do serviço ECS                 | number         | 1                                                  |
| scale_up_cpu_threshold | Limite percentual de CPU para escalonamento para cima | number         | 75                                                 |
| scale_down_cpu_threshold | Limite percentual de CPU para escalonamento para baixo | number         | 25                                                 |
| scale_up_cooldown      | Cooldown (segundos) após escalonamento para cima | number         | 300                                                |
| scale_down_cooldown    | Cooldown (segundos) após escalonamento para baixo | number         | 300                                                |

## Outputs

| Nome                | Descrição           |
|---------------------|---------------------|
| ecr_uri             | url do ecr          |
| rds_endpoint        | Endpoint do RDS     |
| secret_manager_arn  | Secret Manager      |