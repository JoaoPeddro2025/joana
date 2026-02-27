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

# ---- Patch sqlite autocommit arg (py3.11 compatibility) ----
DP_DIR="${ROOT_DIR}/external/diffusion-pipe"
CACHE_PY="${DP_DIR}/utils/cache.py"
if python3.11 - <<'PY2'
import sys
print(int(sys.version_info[:2] <= (3,11)))
PY2
then
  # python command always exits 0; we check output:
  ver=$(python3.11 - <<'PY3'
import sys
print(int(sys.version_info[:2] <= (3,11)))
PY3
)
  if [ "$ver" = "1" ] && [ -f "$CACHE_PY" ]; then
    # remove autocommit kwarg if present
    grep -q "autocommit=False" "$CACHE_PY" && sed -i 's/sqlite3.connect(self.metadata_db, autocommit=False)/sqlite3.connect(self.metadata_db)/g' "$CACHE_PY" && \
      echo "[PATCH] Removed sqlite autocommit kwarg for py<=3.11: $CACHE_PY" || true
  fi
fi
# -----------------------------------------------------------

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
