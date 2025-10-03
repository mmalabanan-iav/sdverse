FROM debian:bookworm-slim

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-pip \
        curl \
        ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages in virtualenv
RUN pip install --no-cache-dir \
        PyPDF2 \
        python-pptx \
        python-docx \
        requests \
        beautifulsoup4

# Install Ollama
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Pre-pull the model during build (this happens at image creation time)
# Start server, pull model, then stop - all in one RUN command
RUN ollama serve & \
    SERVER_PID=$! && \
    sleep 5 && \
    echo "📦 Pulling llama3 model during image build..." && \
    ollama pull llama3 && \
    kill $SERVER_PID && \
    wait $SERVER_PID 2>/dev/null || true

# Set working directory
WORKDIR /sdverse

# Copy application files
COPY sdverse_products.py .
COPY scripts/start.sh .

# Make start script executable
RUN chmod +x start.sh

# Expose Ollama server port (optional, for debugging)
EXPOSE 11434

# Default command: run start.sh
CMD ["./start.sh"]