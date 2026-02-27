#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash ${ROOT_DIR}/scripts/run_train.sh ${ROOT_DIR}/configs/joana_flux/train_smoke.toml
