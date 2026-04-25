#!/bin/bash
# Deploy Hermes + llama.cpp to Luna (Pi) at 192.168.0.49

set -e

PI_HOST="pi@192.168.0.49"
PI_HOME="/home/pi"

echo "=== Deploying Hermes to Luna (Pi) ==="
echo "Target: $PI_HOST"
echo ""

# 1. Ensure Pi is reachable
ssh -o ConnectTimeout=5 "$PI_HOST" "echo 'Luna is online'" || {
    echo "ERROR: Cannot reach Luna. Is the Pi powered on and connected?"
    exit 1
}

# 2. Copy llama.cpp binaries
echo "[1/6] Copying llama.cpp binaries..."
rsync -avz --progress ~/llama.cpp-bin/llama-b8925/ "$PI_HOST:$PI_HOME/llama.cpp-bin/"

# 3. Copy tiny model
echo "[2/6] Copying qwen2.5-0.5b model..."
rsync -avz --progress ~/llama-models/registry.ollama.ai-library-qwen2.5-0.5b.gguf "$PI_HOST:$PI_HOME/llama-models/"

# 4. Copy Hermes config
echo "[3/6] Copying Hermes Pi config..."
ssh "$PI_HOST" "mkdir -p $PI_HOME/.hermes"
rsync -avz pi-deploy/config-pi.yaml "$PI_HOST:$PI_HOME/.hermes/config.yaml"

# 5. Install systemd services
echo "[4/6] Installing systemd services..."
ssh "$PI_HOST" "mkdir -p ~/.config/systemd/user"
rsync -avz pi-deploy/llama-pi.service "$PI_HOST:$PI_HOME/.config/systemd/user/llama-server.service"
rsync -avz pi-deploy/hermes-pi.service "$PI_HOST:$PI_HOME/.config/systemd/user/hermes-gateway.service"

# 6. Enable and start
echo "[5/6] Enabling services..."
ssh "$PI_HOST" "systemctl --user daemon-reload && systemctl --user enable llama-server hermes-gateway"

echo "[6/6] Starting services..."
ssh "$PI_HOST" "systemctl --user start llama-server || true"
ssh "$PI_HOST" "systemctl --user start hermes-gateway || true"

echo ""
echo "=== Deployment complete ==="
echo "Check status: ssh $PI_HOST 'systemctl --user status llama-server hermes-gateway'"
