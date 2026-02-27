#!/usr/bin/env bash
set -euo pipefail

REQ="/workspace/repo/external/diffusion-pipe/requirements.txt"
CON="/workspace/repo/constraints.txt"

echo "== Installing diffusion-pipe deps with constraints =="
python3.11 -m pip install -r "$REQ" -c "$CON"

echo "== Verifying torch trio stays pinned =="
python3.11 - <<'PY'
import torch, torchvision, torchaudio
print(torch.__version__, torchvision.__version__, torchaudio.__version__)
PY