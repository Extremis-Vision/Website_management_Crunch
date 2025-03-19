FROM python:3.8-slim

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    postgresql-client \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Installation des dépendances Python
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

# Création du dossier pour les logs et temp
RUN mkdir -p logs temp && \
    chmod 777 logs temp

CMD ["python", "app.py"]
