# Deploy do site na VM (Ubuntu + Nginx)

A cada push na `main` que altere `FrontEnd/site-cjl/`, o GitHub Actions
(`.github/workflows/deploy.yml`) faz o build do site e envia a pasta `dist/`
para a VM via `rsync` sobre SSH. Também dá para disparar manualmente em
**Actions → Deploy site na VM → Run workflow**.

## 1. Na VM: criar um usuário só para deploy

```bash
sudo adduser --disabled-password --gecos "" deploy
sudo apt-get install -y rsync
sudo mkdir -p /var/www/cjl
sudo chown deploy:www-data /var/www/cjl
sudo chmod 755 /var/www/cjl
```

## 2. No seu computador: gerar a chave de deploy

```bash
ssh-keygen -t ed25519 -C "github-actions-cjl" -f cjl_deploy -N ""
```

Isso cria `cjl_deploy` (privada) e `cjl_deploy.pub` (pública).

Coloque a **pública** na VM:

```bash
sudo -u deploy mkdir -p /home/deploy/.ssh
sudo -u deploy tee -a /home/deploy/.ssh/authorized_keys < cjl_deploy.pub
sudo chmod 700 /home/deploy/.ssh
sudo chmod 600 /home/deploy/.ssh/authorized_keys
```

Pegue a impressão digital do servidor (rode no seu computador, troque o IP):

```bash
ssh-keyscan -p 22 SEU_IP_PUBLICO
```

## 3. No GitHub: cadastrar os secrets

Em **Settings → Secrets and variables → Actions → New repository secret**:

| Secret           | Valor                                                    |
|------------------|----------------------------------------------------------|
| `VM_HOST`        | IP público da VM                                         |
| `VM_USER`        | `deploy`                                                 |
| `VM_SSH_KEY`     | conteúdo inteiro do arquivo `cjl_deploy` (chave privada) |
| `VM_KNOWN_HOSTS` | saída do `ssh-keyscan` acima                             |
| `VM_PORT`        | opcional, só se o SSH não estiver na porta 22            |

Opcional, na aba **Variables**: `VM_PATH` se o site não ficar em `/var/www/cjl`.

Depois de cadastrar, apague o arquivo `cjl_deploy` do seu computador (ou
guarde num cofre de senhas). Nunca faça commit dele.

## 4. Na VM: configurar o Nginx

Use `deploy/nginx-cjl.conf` como base (ajuste `server_name` e `root`):

```bash
sudo cp nginx-cjl.conf /etc/nginx/sites-available/cjl
sudo ln -s /etc/nginx/sites-available/cjl /etc/nginx/sites-enabled/cjl
sudo nginx -t && sudo systemctl reload nginx
```

O `try_files ... /index.html` é obrigatório: o site usa `createWebHistory`
do Vue Router e, sem ele, recarregar uma página interna dá 404.

Para HTTPS com Let's Encrypt:

```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d seudominio.com.br -d www.seudominio.com.br
```

## 5. Testar

Rode o workflow manualmente em **Actions**. Se falhar no passo
"Enviar para a VM", confira no log se é `Permission denied` (chave/usuário)
ou `Host key verification failed` (`VM_KNOWN_HOSTS`).
