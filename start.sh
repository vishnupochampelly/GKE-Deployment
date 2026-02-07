#!/bin/bash
set -e

echo "[STARTING] MultiCloud FinOps Optimizer..."

echo "[INFO] Starting backend..."
cd /app
uvicorn Backend.main:app --host 0.0.0.0 --port 8000 &

echo "[INFO] Starting frontend..."
serve -s /app/Frontend/build -l 3000

wait
