#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DP_DIR="${ROOT_DIR}/external/diffusion-pipe"
REQ="${DP_DIR}/requirements.txt"
CON="${ROOT_DIR}/constraints.txt"

echo "== Installing diffusion-pipe deps with constraints =="
python3.11 -m pip install -r "${REQ}" -c "${CON}"

echo "== Verifying torch trio =="
python3.11 - <<'PY'
import torch, torchvision, torchaudio
print("torch:", torch.__version__)
print("torchvision:", torchvision.__version__)
print("torchaudio:", torchaudio.__version__)
print("cuda available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("gpu:", torch.cuda.get_device_name(0))
PY
