\FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Variables de entorno
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_ORIGINS=*

# Script de inicio que SÍ funciona
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== Iniciando Ollama ==="\n\
echo "Puerto: ${PORT:-11434}"\n\
\n\
# Configurar el host con el puerto de Railway\n\
export OLLAMA_HOST="0.0.0.0:${PORT:-11434}"\n\
export OLLAMA_ORIGINS="*"\n\
\n\
echo "OLLAMA_HOST: $OLLAMA_HOST"\n\
echo "Iniciando servidor..."\n\
\n\
# Iniciar Ollama\n\
exec ollama serve\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 11434

CMD ["/start.sh"]
