#!/bin/bash
set -e

echo "Starting Ollama server..."
# Start Ollama server in the background
ollama serve &

# Wait for Ollama server to be ready
echo " Waiting for Ollama server to start..."
timeout=60
counter=0
while ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; do
    sleep 1
    counter=$((counter + 1))
    if [ $counter -ge $timeout ]; then
        echo "Ollama server failed to start within $timeout seconds"
        exit 1
    fi
done

echo "Ollama server is ready!"
echo "Model already loaded in image!"

# Run the Python script
echo "Starting Python application..."
python sdverse_products.py