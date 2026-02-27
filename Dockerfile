FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace/repo

RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip \
    git curl ca-certificates \
    build-essential cmake ninja-build \
    && rm -rf /var/lib/apt/lists/*

RUN python3.11 -m pip install --upgrade pip setuptools wheel

# garante que "python" exista
RUN ln -s /usr/bin/python3.11 /usr/bin/python

# Torch fixo (cu121)
RUN pip install --index-url https://download.pytorch.org/whl/cu121 \
    torch==2.5.1+cu121 torchvision==0.20.1+cu121 torchaudio==2.5.1+cu121

# Jupyter + HF utils
RUN pip install \
    jupyterlab ipywidgets \
    huggingface_hub[hf_transfer] hf_transfer \
    python-dotenv

# 🔽 Instala deps do diffusion-pipe NO BUILD (sem copiar repo inteiro)
# Copiamos só os arquivos de requirements/constraints do contexto de build
COPY external/diffusion-pipe/requirements.txt /tmp/dp_requirements.txt
COPY constraints.txt /tmp/constraints.txt

# Instala requirements do diffusion-pipe respeitando o torch fixo
RUN python3.11 -m pip install -r /tmp/dp_requirements.txt -c /tmp/constraints.txt

EXPOSE 8888
CMD ["bash", "-lc", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.password=''"]