FROM node:20-bullseye

RUN apt-get update && \
    apt-get install -y python3 python3-pip curl netcat && \
    pip3 install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# React build-time environment variable
ENV REACT_APP_API_URL=http://34.14.218.172:8000


# Copy dependency files
COPY Frontend/package*.json ./Frontend/
COPY Backend/docker-requirements.txt ./Backend/

# Install frontend dependencies
WORKDIR /app/Frontend
RUN npm install --legacy-peer-deps
RUN npm install -g serve

# Install backend dependencies
WORKDIR /app/Backend
RUN pip3 install --no-cache-dir -r docker-requirements.txt

# Copy full project
WORKDIR /app
COPY Frontend ./Frontend
COPY Backend ./Backend
COPY start.sh ./start.sh

# Build frontend
WORKDIR /app/Frontend
RUN npm run build

# Fix Windows line endings
WORKDIR /app
RUN sed -i 's/\r$//' start.sh
RUN chmod +x start.sh

EXPOSE 3000 8000

ENV PYTHONPATH=/app


CMD ["bash", "/app/start.sh"]
