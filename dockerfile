FROM debian:bullseye-slim

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    curl \
    procps \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Script de inicio
RUN cat > /start.sh << 'EOF'
#!/bin/bash
set -e

echo "=== INICIANDO OLLAMA ==="
echo "Puerto asignado por Railway: $PORT"

# Verificar que el puerto esté disponible
if [ -z "$PORT" ]; then
    echo "ERROR: Variable PORT no definida"
    exit 1
fi

# Configurar Ollama
export OLLAMA_HOST=0.0.0.0:$PORT
export OLLAMA_ORIGINS=*

echo "Configuración:"
echo "OLLAMA_HOST=$OLLAMA_HOST"
echo "OLLAMA_ORIGINS=$OLLAMA_ORIGINS"

# Iniciar Ollama
echo "Ejecutando: ollama serve"
exec ollama serve
EOF

RUN chmod +x /start.sh

EXPOSE $PORT

CMD ["/start.sh"]