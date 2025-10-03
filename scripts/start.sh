#!/bin/sh
# Pull the Ollama model if not already present
ollama pull llama3 || true

# Run the Python script
python sdverse_products.py
