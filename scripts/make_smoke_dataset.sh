#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-/workspace/datasets/joana/images}"
DST="/workspace/datasets/joana_smoke2/images"
N="${N_SMOKE:-2}"
RES="${SMOKE_RES:-384}"

mkdir -p "$DST"

if [ ! -d "$SRC" ]; then
  echo "[ERROR] Pasta de origem não existe: $SRC"
  echo "        No Runpod você vai montar o dataset em /workspace/datasets/joana/images"
  exit 1
fi

# Copia N imagens e cria captions curtas
ls "$SRC" | grep -E '\.(jpg|jpeg|png|webp)$' | head -"$N" | while read -r f; do
  base="${f%.*}"
  cp "$SRC/$f" "$DST/"
  if [ -f "$SRC/$base.txt" ]; then
    head -c 400 "$SRC/$base.txt" | tr '\n' ' ' | cut -c1-200 > "$DST/$base.txt"
  else
    echo "portrait photo" > "$DST/$base.txt"
  fi
done

cat > /workspace/repo/configs/joana_flux/dataset_smoke.toml <<TOML
resolutions = [[${RES}, ${RES}]]

directory = [
  { path = "${DST}", caption_extension = ".txt" }
]
TOML

echo "[OK] Smoke dataset criado em: $DST"
echo "[OK] dataset_smoke.toml atualizado para ${RES}x${RES}"
