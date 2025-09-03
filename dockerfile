FROM debian:bullseye-slim

# Instalar todo lo necesario
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Script mejorado
RUN cat > /start.sh << 'EOF'
#!/bin/bash
echo "=== INICIANDO OLLAMA ==="

# Usar puerto fijo si Railway no asigna uno
PORT=${PORT:-11434}
echo "Puerto: $PORT"

# Configurar Ollama
export OLLAMA_HOST=0.0.0.0:$PORT
export OLLAMA_ORIGINS=*

# Esperar un momento antes de iniciar
sleep 5

# Iniciar Ollama en background
echo "Iniciando servidor Ollama..."
ollama serve &

# Esperar a que Ollama esté listo
echo "Esperando que Ollama esté listo..."
sleep 30

# Verificar que está corriendo
if pgrep ollama > /dev/null; then
    echo "✅ Ollama está corriendo"
    # Mantener el contenedor vivo
    while true; do
        sleep 60
        if ! pgrep ollama > /dev/null; then
            echo "❌ Ollama se detuvo, reiniciando..."
            ollama serve &
            sleep 30
        fi
    done
else
    echo "❌ Error: Ollama no pudo iniciar"
    exit 1
fi
EOF

RUN chmod +x /start.sh

EXPOSE 11434

CMD ["./start.sh"]