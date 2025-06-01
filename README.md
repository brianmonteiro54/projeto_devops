# Desafio Técnico: Transformação de uma API Node.js em um Ambiente de Produção

## Objetivo

Este desafio consiste em desenvolver um ambiente de produção robusto e escalável para uma API Node.js, demonstrando habilidades em alta disponibilidade, segurança, contêinerização, automação e provisionamento de infraestrutura.

A infraestrutura é provisionada via **Terraform**, com automação completa utilizando pipelines no **GitHub Actions** para garantir consistência e agilidade no deployment.

Toda a infraestrutura está definida no diretório **infra** e provisionada automaticamente via pipeline CI/CD.

## Requisitos

### 1. Alta Disponibilidade e Escalabilidade
- Arquitetura capaz de escalar a API eficientemente e manter alta disponibilidade.
- Uso de balanceador de carga para distribuir o tráfego entre múltiplas instâncias.

### 2. Segurança
- Práticas de segurança na infraestrutura e código da API.
- Configuração de **Security Groups** para controlar o tráfego de rede.
- Gerenciamento seguro de permissões com **IAM Roles** via **AWS Assume Role (OIDC)**.
- Armazenamento seguro de segredos e credenciais.

### 3. Contêinerização com Docker
- Dockerfile otimizado para construção de imagem leve e eficiente.
- Práticas recomendadas para contêineres e deployment.

### 4. Pipeline Automatizado
- Pipeline de **CI/CD** via **GitHub Actions** para build, teste e deployment automatizados.
- Workflow para provisionamento da infraestrutura com **Terraform** e deploy da aplicação integrado.

### 5. Infraestrutura com Terraform
- Provisionamento idempotente e reutilizável de recursos (ECS Fargate, Load Balancer, RDS, etc.) usando **Terraform**.
- Toda a infraestrutura criada e atualizada automaticamente pelo pipeline.

### 6. Conexões Seguras
- Comunicação segura entre API, banco e serviços internos.
- Uso de certificados **SSL** para proteger dados em trânsito.

## Configuração do Pipeline CI/CD

Para utilizar o pipeline automatizado no GitHub Actions, configure os seguintes **GitHub Secrets** no seu repositório:

- `AWS_ASSUME_ROLE_ARN` — ARN da role IAM que o workflow irá assumir via OIDC (OpenID Connect).  
- `AWS_REGION` — Região AWS onde os recursos serão provisionados.  
- `PRIVATE_KEY` — Chave privada do certificado SSL para conexões seguras.

**Observação:**  
Este método elimina a necessidade de armazenar chaves de acesso estáticas (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`), utilizando autenticação temporária via token OIDC para maior segurança.

# simple-api

## Descrição
Uma API em Node.js utilizando o Express Framework que realiza a conexão com um banco de dados PostgreSQL.

## Como utilizar
O comando para iniciar a API é **npm run start**

## Rotas
| Rota | Método | Descrição |
| --- | --- | --- |
/ | GET | Retorna uma mensagem estática.
/connect | GET | Realiza a conexão com o banco e retorna a versão da engine.

## Variáveis de Ambiente
| Nome | Description  | Padrão |
| --- |  --- |  --- |
API_PORT | Port da API Node | 3000
DB_DATABASE | Database do banco de dados | 
DB_ENDPOINT | Endereço do banco de dados | 
DB_PORT | Port do banco de dados | 5432
DB_USERNAME | Usuário do banco de dados | 
DB_PASSWORD | Senha do banco de dados | 
