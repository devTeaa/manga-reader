FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/library/.cache

# libgl1/libglib2.0 needed by opencv (mokuro dep)
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgl1 libglib2.0-0 curl \
    && rm -rf /var/lib/apt/lists/*

# mokuro first (resolves its own deps), then force a matched torch pair

RUN pip install mokuro gallery-dl
RUN pip install --no-deps torch==2.5.1 torchvision==0.20.1

WORKDIR /library
VOLUME /library
EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
