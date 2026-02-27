import os
import sys
from pathlib import Path

def main():
    repo_id = os.environ.get("FLUX_REPO", "black-forest-labs/FLUX.1-dev")
    local_dir = Path(os.environ.get("FLUX_DIR", "/workspace/models/flux1-dev"))
    token = os.environ.get("HF_TOKEN")

    if not token:
        print("[ERROR] HF_TOKEN não definido.", file=sys.stderr)
        sys.exit(1)

    local_dir.mkdir(parents=True, exist_ok=True)

    # Heurística simples pra idempotência: se existir model_index.json, assume ok
    marker = local_dir / "model_index.json"
    if marker.exists() and marker.stat().st_size > 0:
        print(f"[OK] FLUX já parece baixado em: {local_dir}")
        return

    print(f"Downloading {repo_id} -> {local_dir}")
    try:
        from huggingface_hub import snapshot_download
    except Exception as e:
        print("[ERROR] huggingface_hub não disponível. Rode scripts/setup_diffusion_pipe.sh", file=sys.stderr)
        raise

    snapshot_download(
        repo_id=repo_id,
        local_dir=str(local_dir),
        token=token,
        # por padrão baixa tudo; deixa robusto
        resume_download=True,
    )

    if not marker.exists():
        print("[WARN] Download terminou mas model_index.json não apareceu. Verifique permissões/paths.", file=sys.stderr)
    else:
        print(f"[OK] Download completo: {local_dir}")

if __name__ == "__main__":
    main()
