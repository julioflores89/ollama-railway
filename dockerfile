FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y curl procps

WORKDIR /app

RUN curl -fsSL https://ollama.com/install.sh | sh

CMD ["sh", "-c", "OLLAMA_HOST=0.0.0.0:$PORT ollama serve"]