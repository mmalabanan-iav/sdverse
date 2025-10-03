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

# Install Ollama (interactive install, will complete at runtime)
RUN curl -k -fsSL https://ollama.ai/install.sh | sh

# Add Ollama binary to PATH
ENV PATH="/usr/local/ollama:$PATH"

# Set working directory
WORKDIR /sdverse

# Copy application
COPY sdverse_products.py .

# Copy start script
COPY scripts/start.sh .

# Make sure it’s executable
RUN chmod +x start.sh

# Default command: run start.sh
CMD ["./start.sh"]
# CMD ["/bin/bash"]