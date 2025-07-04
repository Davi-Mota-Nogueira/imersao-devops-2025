# 1. Define a imagem base. A versão 'alpine' é uma boa escolha por ser leve.
# O README menciona Python 3.10 ou superior, então a 3.11 é uma escolha segura e estável.
FROM python:3.13.4-alpine3.22

# 2. Define o diretório de trabalho dentro do contêiner.
# Todos os comandos subsequentes serão executados a partir deste diretório.
WORKDIR /app

# 3. Copia o arquivo de dependências para o diretório de trabalho.
# Fazemos isso em um passo separado para aproveitar o cache de camadas do Docker.
# A camada de dependências só será reconstruída se o requirements.txt mudar.
COPY requirements.txt .

# 4. Instala as dependências do projeto.
# O --no-cache-dir reduz o tamanho da imagem final.
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia todo o código da aplicação para o diretório de trabalho.
COPY . .

# 6. Expõe a porta que o Uvicorn usará, permitindo a comunicação com o contêiner.
EXPOSE 8000

# 7. Comando para iniciar a aplicação quando o contêiner for executado.
# Usamos --host 0.0.0.0 para que a API seja acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]