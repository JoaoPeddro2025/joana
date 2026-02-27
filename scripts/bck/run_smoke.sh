#!/usr/bin/env bash
set -euo pipefail

cd /workspace/repo

echo "WANDB_MODE=${WANDB_MODE:-unset}"
python3.11 external/diffusion-pipe/train.py --config configs/joana_flux/train_smoke.toml