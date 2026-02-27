#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Python ==="
python3.11 -V || true
python -V || true

echo "=== GPU (nvidia-smi) ==="
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi
else
  echo "[WARN] nvidia-smi não encontrado."
fi

echo "=== Torch versions ==="
python3.11 - <<'PY'
import torch
print("torch     ", torch.__version__)
try:
  import torchvision
  print("torchvision", torchvision.__version__)
except Exception as e:
  print("torchvision: (erro)", e)
try:
  import torchaudio
  print("torchaudio", torchaudio.__version__)
except Exception as e:
  print("torchaudio: (erro)", e)
print("cuda available:", torch.cuda.is_available())
if torch.cuda.is_available():
  print("gpu:", torch.cuda.get_device_name(0))
PY

echo "=== HF token present? ==="
if [ -n "${HF_TOKEN:-}" ]; then
  echo "HF_TOKEN: OK (length ${#HF_TOKEN})"
else
  echo "[ERROR] HF_TOKEN não definido."
  echo "        Exporte antes de rodar:"
  echo "        export HF_TOKEN='hf_...'"
  exit 1
fi
