#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd ${ROOT_DIR}

echo "=== (1/5) check_env ==="
bash scripts/check_env.sh

echo "=== (2/5) setup diffusion-pipe deps ==="
bash scripts/setup_diffusion_pipe.sh

echo "=== (3/5) download FLUX (se necessário) ==="
python3.11 scripts/download_flux1_dev.py

echo "=== (4/5) make smoke dataset ==="
bash scripts/make_smoke_dataset.sh

echo "=== (5/5) train smoke ==="
bash scripts/run_train.sh ${ROOT_DIR}/configs/joana_flux/train_smoke.toml

echo "[OK] Fim do smoke run."
