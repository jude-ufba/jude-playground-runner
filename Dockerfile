FROM ubuntu:22.04

LABEL jude.playground.runner.version="2025-12-27"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git unzip \
        build-essential \
        openjdk-17-jdk \
        python3 python3-pip \
        mono-devel \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && npm i -g typescript @types/node \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash sandbox \
    && mkdir -p /workspace \
    && chown -R sandbox:sandbox /workspace

USER sandbox
WORKDIR /workspace

CMD ["bash"]
