# Usar uma imagem base leve do Python
FROM python:3.8-slim

# Instalar wget
RUN apt-get update && apt-get install -y wget

# Criar diretório de trabalho
WORKDIR /opt/app/

# Copiar o conteúdo do diretório app/ para /opt/app/
COPY app/ /opt/app/

# Expor a porta 3246
EXPOSE 3246

# Definir o comando padrão para executar o aplicativo
CMD ["python", "echo.py"]
