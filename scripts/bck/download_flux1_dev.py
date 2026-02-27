import os
from huggingface_hub import snapshot_download

REPO_ID = "black-forest-labs/FLUX.1-dev"
LOCAL_DIR = "/workspace/models/flux1-dev"

token = os.getenv("HF_TOKEN")
if not token:
    raise SystemExit("HF_TOKEN não encontrado. Defina via .env (docker compose) ou env var (Runpod).")

print(f"Downloading {REPO_ID} -> {LOCAL_DIR}")
snapshot_download(
    repo_id=REPO_ID,
    local_dir=LOCAL_DIR,
    local_dir_use_symlinks=False,
    token=token,
)
print("Done.")
