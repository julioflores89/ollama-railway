FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.com/install.sh | sh

# Variables críticas para Railway
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_ORIGINS=*

# Script optimizado para Railway
RUN echo '#!/bin/bash\n\
export OLLAMA_HOST="0.0.0.0:${PORT}"\n\
echo "Iniciando Ollama en puerto ${PORT}"\n\
exec ollama serve' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
