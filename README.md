# Desafio Técnico: Transformação de uma API Node.js em um Ambiente de Produção

## Objetivo

O objetivo deste desafio é desenvolver um ambiente de produção robusto e escalável para uma API Node.js, incorporando as melhores práticas de engenharia de software e infraestrutura. Este projeto é uma oportunidade para demonstrar habilidades em áreas fundamentais, como alta disponibilidade, segurança, contêinerização, automação e provisionamento de infraestrutura.

## Requisitos

### 1. Alta Disponibilidade e Escalabilidade
- Implementar uma arquitetura que garanta a capacidade de escalar a API de forma eficiente, mantendo alta disponibilidade para suportar aumentos de tráfego.
- Utilizar técnicas de balanceamento de carga para distribuir o tráfego entre múltiplas instâncias da aplicação.

### 2. Segurança
- Adotar boas práticas de segurança na infraestrutura e no código da API.
- Implementar o uso de **Security Groups** para controlar o tráfego de rede.
- Configurar **IAM Roles** para gerenciar permissões de acesso de forma segura.
- Garantir o gerenciamento seguro de segredos e credenciais.

### 3. Contêinerização com Docker
- Criar um **Dockerfile** otimizado para a aplicação, seguindo as melhores práticas de contêinerização.
- Configurar imagens que garantam eficiência e leveza no deployment.

### 4. Pipeline Automatizado
- Configurar um pipeline de **CI/CD** para automatizar o processo de build, teste e deployment da aplicação.
- Assegurar um ciclo de vida ágil e controlado para o desenvolvimento e a entrega de novas funcionalidades.

### 5. Infraestrutura com Terraform
- Provisionar todos os recursos de infraestrutura (como **ECS Fargate**, **Load Balancer**, **RDS**, etc.) utilizando **Terraform**.
- Garantir que todos os recursos sejam criados de forma idempotente e reutilizável, facilitando a gestão e manutenção da infraestrutura.

### 6. Conexões Seguras
- Certificar-se de que toda a comunicação entre os recursos (API, banco de dados, serviços internos) ocorra de forma segura.
- Implementar o uso de certificados **SSL** e seguir outras práticas recomendadas de segurança para proteger os dados em trânsito.


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
DB_HOST | Endereço do banco de dados | 
DB_PORT | Port do banco de dados | 5432
DB_USER | Usuário do banco de dados | 
DB_PASSWORD | Senha do banco de dados | 