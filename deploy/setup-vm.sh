#!/usr/bin/env bash
# Preparação da VM para o deploy da CJL. Roda uma vez, como root, a partir de um clone deste repositório:
#
#   sudo bash deploy/setup-vm.sh /caminho/cjl_ci.pub [/caminho/cjl_deploy.pub ...]
#
# Cria o usuário restrito `cjldeploy` (só git-shell, sem terminal), o repo bare que recebe o push,
# o hook, o script de deploy em /opt/cjl-deploy e a única regra de sudo que esse usuário tem.
# Pode rodar de novo: o que já existe é mantido e as chaves só são acrescentadas.
set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "rode como root (sudo)"; exit 1; }
[ "$#" -ge 1 ] || { echo "uso: $0 chave.pub [outra.pub ...]"; exit 1; }

HERE="$(cd "$(dirname "$0")" && pwd)"
USER_NAME=cjldeploy
HOME_DIR=/home/$USER_NAME
GITDIR=$HOME_DIR/cjl.git
GIT_SHELL="$(command -v git-shell)"

docker network inspect saplink_default >/dev/null \
  || { echo "rede saplink_default (Caddy) não encontrada"; exit 1; }

grep -qx "$GIT_SHELL" /etc/shells || echo "$GIT_SHELL" >> /etc/shells
id "$USER_NAME" >/dev/null 2>&1 \
  || useradd --create-home --home-dir "$HOME_DIR" --shell "$GIT_SHELL" "$USER_NAME"

# chaves: só podem fazer git push, sem túnel nem terminal
install -d -m 700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.ssh"
AUTH="$HOME_DIR/.ssh/authorized_keys"
touch "$AUTH"
for pub in "$@"; do
  key="$(cat "$pub")"
  grep -qF "$key" "$AUTH" || echo "restrict $key" >> "$AUTH"
done
chown "$USER_NAME:$USER_NAME" "$AUTH"
chmod 600 "$AUTH"

[ -d "$GITDIR" ] || sudo -u "$USER_NAME" git init -q --bare "$GITDIR"
install -m 755 -o "$USER_NAME" -g "$USER_NAME" "$HERE/post-receive" "$GITDIR/hooks/post-receive"

install -d -m 755 /opt/cjl-deploy
install -m 755 -o root -g root "$HERE/server-deploy.sh" /opt/cjl-deploy/deploy.sh

SUDOERS=/etc/sudoers.d/cjldeploy
echo "$USER_NAME ALL=(root) NOPASSWD: /opt/cjl-deploy/deploy.sh" > "$SUDOERS.tmp"
visudo -cf "$SUDOERS.tmp" >/dev/null
chmod 440 "$SUDOERS.tmp"
mv "$SUDOERS.tmp" "$SUDOERS"

echo "pronto: $USER_NAME@$(hostname):cjl.git recebe o push da main"
