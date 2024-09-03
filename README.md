# Introdução

A Docket precisa desenvolver infraestrutura na AWS para a execução de uma aplicação python que vai ser executada em um cluster ECS.
Seu objetivo é construir um container a partir do código fonte e fazer a publicação manual dele em um cluster ECS a ser criado usando Terraform.

A organização da gestão de mudanças via git faz parte do teste.

Ao final, faça o PR de suas alterações.

## Requisitos

Serão necessários as seguintes ferramentas para executar esse exercício:
- Terraform
- Docker
- AWS CLI versão 2

## Credenciais

- user:  vinicius.monteiro
- senha: xA330gA@
- Console sign-in URL: https://010928223552.signin.aws.amazon.com/console
- Access key: AKIAQFC27OVAAFHXL5U7
- Secret access key:  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

# Projeto

## Docker

Usando Docker, crie:

- Crie uma imagem Docker para a aplicação python que está no diretório app/
- A imagem gerada deve chamar "echo_python".
- Copie todo o conteúdo do diretório app/ para o opt/app/ dentro da imagem.

O programa é executado usando o comando:

```sh
python echo.py
```
- A imagem final deve ter menos de 500 MB de tamanho.
- A porta 3246 deve ficar exposta para conexões.
- Instale o comando wget na imagem.

## Terraform

No diretório terraform já existe uma stack Terraform inicial que cria um App ELB na sua conta AWS.
Para o exercício não é permitido usar modulos para sua construção, apenas resources.

- Usando Terraform crie um repositório ECR de nome "echo_python" no arquivo terraform/ecr.tf
- Faça deploy da stack.

## Bash

Usando Bash, crie

- Crie um script Bash que faça build da imagem e a envie para o repositorio ECR.
O script deve ficar no arquivo bin/build_project.sh
- O script deve verificar se as variáveis de ambiente de credenciais da AWS existem e
possuem algum valor (not null). Se alguma das variáveis de ambiente estiver faltando,
gere uma mensagem de erro e interrompa a execução do sscript.
- Use o script para fazer upload da imagem para o ECR criado no exercício anterior.
- O script não precisa receber quaisquer valores como parâmetro. Só ser executável.

## Terraform

O objetivo desse exercício é criar um serviço em ECS que responda à requisições HTTP GET via um App ELB.

Não é permitido usar modulos para sua construção, apenas resources.

Usando Terraform, crie:

- Crie um cluster ECS de nome "my_cluster" usando o capacity provider FARGATE
- Crie um serviço "echo_python" no cluster "my_cluster".
    - O serviço "echo_python" deve receber requisições a partir do App Load Balancer "int-abl" pela porta 80 e redirecionados para a porta 3246 do container.
    - o healthcheck pode ser feito usando o comando "curl --fail -I http://localhost:3246"
- Crie uma Task Definition de nome "echo_python" com as seguintes características:
    - 2G de memória
    - 1 vcpu



