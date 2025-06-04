FROM python:3.12-slim

# Define o diretório de trabalho no container
WORKDIR /app

# Instala bibliotecas de sistema necessárias
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Evita criação de arquivos .pyc e ativa logs imediatos
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copia dependências
COPY requirements.txt .

# Instala dependências Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia os arquivos do backend
COPY FinderBack/app /app/app
COPY FinderBack/main.py /app/main.py
COPY .env /app/.env

# Copia a pasta FinderInference/production como módulo
COPY FinderInference/production /app/FinderInference

# Expõe a porta da aplicação
EXPOSE 8030

# Comando de entrada
CMD ["python", "main.py"]
