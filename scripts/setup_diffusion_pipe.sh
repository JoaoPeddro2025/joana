#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DP_DIR="${ROOT_DIR}/external/diffusion-pipe"
REQ="${DP_DIR}/requirements.txt"
CON="${ROOT_DIR}/constraints.txt"

if [ ! -f "$REQ" ]; then
  echo "[ERROR] requirements não encontrado: $REQ"
  exit 1
fi

echo "== Installing diffusion-pipe deps with constraints =="
if [ -f "$CON" ]; then
  python3.11 -m pip install -r "$REQ" -c "$CON"
else
  echo "[WARN] constraints.txt não encontrado em $CON"
  echo "       Instalando sem constraints (não recomendado pra RunPod)."
  python3.11 -m pip install -r "$REQ"
fi

echo "


== Verifying torch trio =="
python3.11 - <<'PY'
import torch
print("torch:", torch.__version__)
try:
  import torchvision; print("torchvision:", torchvision.__version__)
except Exception as e:
  print("torchvision: (erro)", e)
try:
  import torchaudio; print("torchaudio:", torchaudio.__version__)
except Exception as e:
  print("torchaudio: (erro)", e)
PY
