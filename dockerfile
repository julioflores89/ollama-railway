FROM ollama/ollama:latest

# Simple y directo
ENV OLLAMA_HOST=0.0.0.0
ENV PORT=11434

EXPOSE 11434

CMD ["sh", "-c", "ollama serve --host 0.0.0.0:${PORT}"] 
