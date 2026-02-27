#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure ComfyUI is importable as 'comfy' (ComfyUI submodule)
export PYTHONPATH="${ROOT_DIR}/external/diffusion-pipe:${ROOT_DIR}/external/diffusion-pipe/submodules/ComfyUI:${PYTHONPATH:-}"


CFG="${1:-${ROOT_DIR}/configs/joana_flux/train_smoke.toml}"
ADDR="${MASTER_ADDR:-127.0.0.1}"
BASE_PORT="${MASTER_PORT:-31337}"

if [ ! -f "$CFG" ]; then
  echo "[ERROR] Config não existe: $CFG"
  exit 1
fi

# evita warning do triton
mkdir -p /root/.triton/autotune || true

# sanity: modelo existe
if [ ! -f "/workspace/models/flux1-dev/model_index.json" ]; then
  echo "[WARN] /workspace/models/flux1-dev/model_index.json não encontrado."
  echo "       Rode scripts/download_flux1_dev.py antes (ou run_smoke_all.sh)."
fi

choose_port () {
  local p
  for p in "$BASE_PORT" 31338 31339 31400 31401 31402 29500 29501 29502; do
    python3.11 - <<PY >/dev/null 2>&1 && { echo "$p"; return 0; } || true
import socket, sys
p = int("$p")
s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
try:
    s.bind(("127.0.0.1", p))
except OSError:
    sys.exit(1)
finally:
    try: s.close()
    except: pass
PY
  done
  echo "[ERROR] Nenhuma porta livre encontrada." >&2
  return 1
}

PORT="$(choose_port)"

cd ${ROOT_DIR}/external/diffusion-pipe

echo "[INFO] MASTER_ADDR=$ADDR"
echo "[INFO] MASTER_PORT=$PORT"
echo "[INFO] Config: $CFG"

export MASTER_ADDR="$ADDR"
export MASTER_PORT="$PORT"

deepspeed --num_gpus=1 --master_port "$PORT" train.py --config "$CFG"
