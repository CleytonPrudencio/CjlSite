#!/usr/bin/env bash
# Script de deploy do lado do SERVIDOR (vive em /opt/cjl-deploy/deploy.sh, dono root, 755).
# É chamado pelo hook post-receive do repo bare (/home/cjldeploy/cjl.git) via sudo,
# quando o usuário restrito `cjldeploy` recebe um `git push deploy <branch>`.
#
# Só mexe em /opt/cjl e no container da CJL (cjl-site). Este arquivo é cópia versionada da fonte
# da verdade que roda na VM: mudou aqui, precisa ser copiado para lá por quem tem root.
set -euo pipefail

BRANCH="${1:-}"
case "$BRANCH" in
  main) SRC=/opt/cjl; SERVICE=cjl-site ;;
  *) echo "branch nao deployavel: $BRANCH"; exit 0 ;;
esac

GITDIR=/home/cjldeploy/cjl.git
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# extrai a arvore do branch sem depender do indice do repo bare
git --git-dir="$GITDIR" archive "$BRANCH" | tar -x -C "$TMP"

install -d -m 755 "$SRC"
rsync -a --delete "$TMP"/ "$SRC"/

cd "$SRC"
docker compose up -d --build
# limpa só as imagens soltas do projeto cjl; a VM é compartilhada
docker image prune -f --filter label=com.docker.compose.project=cjl >/dev/null 2>&1 || true
echo "deploy de $BRANCH -> $SERVICE OK"
