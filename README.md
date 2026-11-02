# shared-pipelines

Workflows reutilizáveis (`java`, `node`, `go`, `graalvm`). No repo do microsserviço:

```yaml
name: CI/CD
on: { push: { branches: [main] } }
jobs:
  pipeline:
    uses: kube-automations-v1/shared-pipelines/.github/workflows/<tech>-template.yml@main
    permissions: { contents: read, packages: write }   # obrigatório (workflow reutilizável aninhado)
    secrets: inherit   # precisa de GITOPS_PAT na org
```

Cada template roda testes e chama `_deploy.yml`: build da imagem (Dockerfile do repo ou `dockerfiles/<tech>.Dockerfile`),
push no GHCR e commit no `cluster-gitops` (cria `apps/<ms>` no primeiro deploy). O app deve escutar na porta **8080**.
Resultado: `http://automation-v1/<tech>/<ms>`.

## Bases de dados (`base-*`)
Repos de bancos seguem o nome `base-<nome>` e usam `postgres-template.yml@main` (build + smoke test + deploy via `new-base.sh`,
que cria `apps/base-<nome>` no cluster-gitops com StatefulSet, PVC persistente e backup diário).

```yaml
jobs:
  pipeline:
    uses: kube-automations-v1/shared-pipelines/.github/workflows/postgres-template.yml@main
    permissions: { contents: read, packages: write }
    secrets: inherit
```
