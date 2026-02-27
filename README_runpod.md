# FLUX LoRA (diffusion-pipe) — RunPod Ready

Treino LoRA do FLUX.1-dev usando DeepSpeed + diffusion-pipe.

## Requisitos
- GPU NVIDIA (ex: A6000 48GB recomendado)
- Python 3.11
- HF_TOKEN com acesso ao modelo: black-forest-labs/FLUX.1-dev

## Dataset (imagens + captions)
As captions devem ter o mesmo nome da imagem.

Exemplo:
- img001.jpg + img001.txt
- img002.png + img002.txt

Estrutura recomendada:
/workspace/datasets/joana/images/
  img001.jpg
  img001.txt
  img002.jpg
  img002.txt

## Rodar (Clone → 1 comando)
cd /workspace
git clone <SEU_REPO_AQUI> repo
cd repo

export HF_TOKEN="hf_xxxxxxxxx"

bash scripts/run_smoke_all.sh

## Outputs
/workspace/outputs/joana_flux/<timestamp>/
epoch1/pytorch_lora_weights.safetensors
