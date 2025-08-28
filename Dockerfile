FROM python:3.9-slim

# Prevents Python from writing .pyc files & buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1         PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies (optional, kept minimal for slim image)
RUN apt-get update && apt-get install -y --no-install-recommends         ca-certificates         && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# Use gunicorn in container for better signal handling
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
