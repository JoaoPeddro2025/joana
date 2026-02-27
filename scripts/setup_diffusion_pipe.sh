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
python3.11 - <<'PY2'
import sys
from pathlib import Path
major, minor = sys.version_info[:2]
if (major, minor) <= (3, 11):
    p = Path("${DP_DIR}/utils/cache.py")
    if p.exists():
        s = p.read_text()
        if "autocommit=False" in s:
            p.write_text(s.replace("sqlite3.connect(self.metadata_db, autocommit=False)", "sqlite3.connect(self.metadata_db)"))
            print("[PATCH] Removed sqlite autocommit kwarg for py<=3.11:", p)
        else:
            print("[PATCH] sqlite autocommit not present:", p)
PY2
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
