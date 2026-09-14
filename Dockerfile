FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/library/.cache

# libgl1/libglib2.0 needed by opencv (mokuro dep)
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgl1 libglib2.0-0 curl \
    && rm -rf /var/lib/apt/lists/*

# CPU-only torch first so we don't pull ~2GB CUDA wheels
RUN pip install torch --index-url https://download.pytorch.org/whl/cpu

RUN pip install mokuro gallery-dl

WORKDIR /library
VOLUME /library
EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
