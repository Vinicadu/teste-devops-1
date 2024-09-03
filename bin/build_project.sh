#!/bin/bash

# Verificar se as variáveis de ambiente de credenciais da AWS existem e possuem algum valor
if [[ -z "AKIAQFC27OVAAFHXL5U7" || -z "CJSUY5EgTECchjMFL1hY2mhWXNoTxYDhZ+TuhcY+" ]]; then
  echo "Erro: Variáveis de ambiente de credenciais da AWS não encontradas."
  exit 1
fi

# Build da imagem Docker
docker build -t echo_python .

# Fazer login no ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 010928223552.dkr.ecr.us-east-1.amazonaws.com

# Tag da imagem
docker tag echo_python:latest 010928223552.dkr.ecr.us-east-1.amazonaws.com/echo_python:latest

# Push da imagem para o ECR
docker push 010928223552.dkr.ecr.us-east-1.amazonaws.com/echo_python:latest