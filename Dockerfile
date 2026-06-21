# Use a lightweight, stable Python image
FROM python:3.11-slim

# Prevent Python from writing .pyc files and enable unbuffered logging
# Crucial for MCP servers communicating over stdio
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies if required (arxiv or standard packages sometimes need curl)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first to leverage Docker caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the server code into the container
# (Assumes your python file is named server.py)
COPY server.py .

# Run the FastMCP server via stdio
CMD ["python", "server.py"]