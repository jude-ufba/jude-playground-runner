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

## Build

```bash
docker build -t judeufba/jude-playground-runner .
```

Imagem publicada: [`judeufba/jude-playground-runner`](https://hub.docker.com/r/judeufba/jude-playground-runner) (CI publica `latest` + short-hash a cada push em `main`).
