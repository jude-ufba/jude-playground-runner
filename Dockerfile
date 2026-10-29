FROM ubuntu:22.04

LABEL jude.playground.runner.version="2026-10-29"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git unzip \
        build-essential \
        openjdk-17-jdk \
        python3 python3-pip \
        mono-devel \
    && rm -rf /var/lib/apt/lists/*

# Cabeçalho pré-compilado do bits/stdc++.h: o Run de C++ compila ~4x mais rápido
# e com bem menos memória. As flags têm de ser as mesmas do Run no backend
# (jude-backend-api, app/contest/playground/protocol.py); com flags diferentes o
# g++ ignora o .gch sem erro e volta a compilar o cabeçalho inteiro. O build
# falha se o g++ não usar o .gch.
ARG PCH_FLAGS="-std=c++17 -O2"
RUN header="$(echo '#include <bits/stdc++.h>' | g++ $PCH_FLAGS -x c++ -E -H - 2>&1 >/dev/null \
        | awk '/\/bits\/stdc\+\+\.h$/ {print $2; exit}')" \
    && test -f "$header" \
    && g++ $PCH_FLAGS -x c++-header "$header" -o "$header.gch" \
    && printf '#include <bits/stdc++.h>\nint main() {}\n' > /tmp/pch-check.cpp \
    && g++ $PCH_FLAGS -H -fsyntax-only /tmp/pch-check.cpp 2>&1 | grep -q "^! $header.gch" \
    && rm /tmp/pch-check.cpp

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
