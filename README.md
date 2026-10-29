# jude-playground-runner

Imagem sandbox com as toolchains usadas pelo playground do [Jude](https://jude.dcc.ufba.br/) (UFBA Online Judge) para compilar e executar código interativamente.

A imagem é **passiva**: não tem serviço próprio. O backend do Jude cria containers efêmeros a partir dela (via `docker-socket-proxy`) com usuário não-root (`sandbox`) e workdir `/workspace`.

## Toolchains incluídas

| Linguagem | Ferramenta |
|---|---|
| C / C++ | `build-essential` (gcc/g++) |
| Java | OpenJDK 17 |
| Python | Python 3 + pip |
| C# | Mono |
| JavaScript / TypeScript | Node.js 20 + `typescript` |

## Cabeçalho pré-compilado (C++)

A imagem traz o `bits/stdc++.h` pré-compilado (`stdc++.h.gch`, ao lado do cabeçalho). Código que começa com `#include <bits/stdc++.h>` compila cerca de 4x mais rápido e com bem menos memória; o resto compila como sempre.

O `.gch` vale só para as flags com que foi gerado (`PCH_FLAGS` no `Dockerfile`, hoje `-std=c++17 -O2`), que precisam ser as mesmas do Run de C++ no backend (`jude-backend-api`, `app/contest/playground/protocol.py`). Com flags diferentes o g++ ignora o `.gch` sem erro e o Run volta a ficar lento: mude os dois juntos. O build falha se o g++ não usar o `.gch`.

Para conferir numa imagem: `echo '#include <bits/stdc++.h>' | g++ -std=c++17 -O2 -H -fsyntax-only -x c++ - 2>&1 | grep '^!'` mostra o `.gch` em uso.

## Build

```bash
docker build -t judeufba/jude-playground-runner .
```

Imagem publicada: [`judeufba/jude-playground-runner`](https://hub.docker.com/r/judeufba/jude-playground-runner) (CI publica `latest` + short-hash a cada push em `main`).
