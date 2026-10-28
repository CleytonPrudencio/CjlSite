# Deploy — site da CJL

Mesmo padrão do Mergi (`CleytonPrudencio/devz`): o site roda num container próprio na mesma VM,
atrás do Caddy compartilhado, que faz o TLS.

| Container | O que é | Fala com |
|---|---|---|
| `cjl-site` | site (Vue 3 + Vite) servido por nginx | Caddy |

> Host, chaves SSH e IP não ficam neste repositório. Abaixo, `<SERVIDOR>` é um placeholder.

## Isolamento

O site divide a VM com outros sistemas, mas não divide nada além da entrada de tráfego:

- usuário próprio no servidor (`cjldeploy`), com `git-shell` e uma única permissão de sudo: rodar `/opt/cjl-deploy/deploy.sh`;
- chaves SSH próprias, que não abrem nenhum outro app;
- pasta própria (`/opt/cjl`) e projeto Docker próprio (`cjl`), com teto de 64 MB de memória e 0,25 CPU;
- a única coisa compartilhada é a rede do Caddy (`saplink_default`) e o bloco da CJL no Caddyfile.

## Deploy automático

Todo push na `main` do GitHub dispara o workflow `.github/workflows/deploy.yml`:

1. roda `npm ci` + `npm run build` em `FrontEnd/site-cjl` (type-check incluso);
2. se o build passar, faz `git push` para o servidor com uma chave só de deploy;
3. o servidor reconstrói o container (`docker compose up -d --build`), pelo hook `post-receive`;
4. se a variável `CJL_SITE_URL` estiver definida, o workflow confere se o site respondeu 200.

Também dá para disparar à mão em **Actions → deploy → Run workflow**.

## Configuração inicial (uma vez)

### 1. Gerar as chaves (no seu computador)

```bash
ssh-keygen -t ed25519 -C "cjl-ci"     -f cjl_ci     -N ""   # só do GitHub Actions
ssh-keygen -t ed25519 -C "cjl-deploy" -f cjl_deploy        # para deploy manual (com senha)
```

### 2. Preparar a VM (como root)

Copie as chaves **públicas** para a VM e rode, a partir de um clone deste repositório:

```bash
sudo bash deploy/setup-vm.sh cjl_ci.pub cjl_deploy.pub
```

O script cria o usuário `cjldeploy`, o repo bare `/home/cjldeploy/cjl.git` com o hook,
o `/opt/cjl-deploy/deploy.sh` e a regra de sudo. Pode rodar de novo sem estragar nada.

### 3. Caddy

O Caddy é único para todos os sistemas da VM (container `saplink-caddy`, arquivo
`/opt/saplink/deploy/Caddyfile`). O arquivo é um bind mount de arquivo único: edite **só
acrescentando** (`cat >>`), **nunca** com `sed -i`, senão o container perde o arquivo.

Troque `<DOMINIO>` em `deploy/Caddyfile.cjl` pelo domínio da CJL e, na VM:

```bash
cp /opt/saplink/deploy/Caddyfile /opt/saplink/deploy/Caddyfile.bak-$(date +%F)
cat deploy/Caddyfile.cjl >> /opt/saplink/deploy/Caddyfile
docker exec saplink-caddy caddy validate --config /etc/caddy/Caddyfile
docker exec saplink-caddy caddy reload --config /etc/caddy/Caddyfile
```

Se o `validate` reclamar, volte o backup antes de qualquer `reload`. Enquanto o DNS do domínio
não aponta para a VM, dá para usar `cjl.<IP-DA-VM>.sslip.io`, que já resolve e ganha certificado
sozinho. O passo a passo de acesso à VM (usuário, chave, atalho SSH) está em
`docs/vm-runbook.md` no repositório do Mergi (`devz`).

### 4. GitHub

Em **Settings → Secrets and variables → Actions**:

| Tipo | Nome | Valor |
|---|---|---|
| Secret | `CJL_DEPLOY_KEY` | conteúdo do arquivo `cjl_ci` (chave privada do CI) |
| Secret | `CJL_KNOWN_HOSTS` | saída de `ssh-keyscan <SERVIDOR>` |
| Secret | `CJL_DEPLOY_HOST` | IP ou nome da VM |
| Variable | `CJL_SITE_URL` | `https://<DOMINIO>` (opcional, liga a checagem final) |

Depois de cadastrar, apague o `cjl_ci` do seu computador. Nunca faça commit de chave privada.

## Deploy manual (se o GitHub Actions estiver fora)

```bash
# uma vez, no seu clone:
git remote add deploy cjldeploy@<SERVIDOR>:cjl.git

GIT_SSH_COMMAND="ssh -i ~/.ssh/cjl_deploy -o IdentitiesOnly=yes" git push deploy main
```

## Arquivos

- `Dockerfile`, `docker-compose.yml`, `deploy/nginx.conf`, `deploy/headers.conf`: site e orquestração.
- `deploy/setup-vm.sh`: preparação da VM (usuário, repo bare, hook, sudo).
- `deploy/server-deploy.sh`, `deploy/post-receive`: cópias do que roda na VM. Mudou aqui, rode o `setup-vm.sh` de novo para levar para lá.
- `deploy/Caddyfile.cjl`: cópia do bloco da CJL no Caddyfile compartilhado.

## Observações

- O Vue Router usa `createWebHistory`: o nginx manda qualquer rota para o `index.html` (por isso recarregar `/contato` funciona).
- A CSP libera só o próprio site e o cdnjs (Font Awesome, carregado no `index.html`). Se o site passar a usar outro serviço externo (mapa, analytics, formulário), ele precisa entrar em `deploy/headers.conf`.
- O formulário de contato ainda não envia para lugar nenhum (`enviarFormulario` só existe no template).
