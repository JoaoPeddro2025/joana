#!/usr/bin/env bash
set -euo pipefail

echo "=== Python ==="
python3.11 -V

echo "=== GPU (nvidia-smi) ==="
nvidia-smi || true

echo "=== Torch versions ==="
python3.11 - <<'PY'
import torch, torchvision, torchaudio
print("torch     ", torch.__version__)
print("torchvision", torchvision.__version__)
print("torchaudio", torchaudio.__version__)
print("cuda available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("gpu:", torch.cuda.get_device_name(0))
PY

echo "=== HF token present? ==="
if [ -n "${HF_TOKEN:-}" ]; then
  echo "HF_TOKEN: OK (length ${#HF_TOKEN})"
else
  echo "HF_TOKEN: MISSING (set in .env or env var)"
fi