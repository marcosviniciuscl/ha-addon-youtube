# Add-on: YouTube para Telegram

Add-on do Home Assistant que recebe links do YouTube por um bot do Telegram,
baixa o vídeo ou o áudio e devolve **no próprio chat**. Se o arquivo passar do
limite do Telegram (50 MB), ele é enviado para o **MinIO** e entregue por um
**link temporário** (pré-assinado), que é apagado depois.

É um programa **separado** — usa um bot do Telegram só para isso, independente do
bot do Holyrics.

## Estrutura do repositório

```
ha-addon-youtube/
├── repository.yaml          # marca esta pasta como repositório de add-ons
└── youtube-telegram/        # o add-on em si
    ├── config.yaml          # manifesto + opções
    ├── Dockerfile
    ├── run.sh
    ├── requirements.txt
    ├── main.py              # bot do Telegram
    ├── yt.py                # yt-dlp (links, opções, download, progresso)
    ├── minio_store.py       # envio/link assinado/remoção no MinIO
    ├── config.py            # lê /data/options.json
    ├── icon.png / logo.png
    └── DOCS.md              # documentação que aparece no Home Assistant
```

## Como instalar no Home Assistant

1. Crie um bot novo no Telegram com o [@BotFather](https://t.me/BotFather) e
   copie o **token**.
2. Descubra seu ID de usuário: fale com o [@userinfobot](https://t.me/userinfobot)
   ou, depois de instalar, use o comando `/id` no seu bot.
3. Suba esta pasta `ha-addon-youtube/` para um repositório no GitHub.
4. No Home Assistant: **Configurações → Add-ons → Loja de add-ons → ⋮ →
   Repositórios**, cole a URL do repositório e clique em **Adicionar**.
   Recarregue a página; o add-on *YouTube para Telegram* vai aparecer.
5. Instale e, na aba **Configuração**, preencha no mínimo:
   - `telegram_token`: o token do BotFather
   - `usuarios_autorizados`: seu ID do Telegram (para ninguém mais usar)
6. Clique em **Iniciar**. O add-on sobe o bot e fica escutando links.

> O `config.yaml`/add-on usa a base oficial `ghcr.io/home-assistant/base` e já
> instala `python3` e `ffmpeg` na imagem. O build roda dentro do próprio HA.

## MinIO (arquivos grandes)

Ative em **Configuração**:

```yaml
minio:
  ativo: true
  endpoint: "https://minio.seudominio.com"   # com http(s):// e, se houver, a porta
  access_key: "SUA_ACCESS_KEY"
  secret_key: "SUA_SECRET_KEY"
  bucket: "youtube-telegram"
  secure: true
  regiao: "us-east-1"
  url_expira_min: 60      # validade do link temporário
  apagar_apos_min: 70     # quando apagar o objeto do MinIO
```

O bucket é criado automaticamente se não existir. O link é **pré-assinado**
(`s3v4`, path-style), então o bucket pode continuar **privado**.

Fluxo: o arquivo é enviado ao MinIO → o bot manda o link e um botão
**“🗑 Já baixei — apagar agora”** → o objeto é apagado quando você clica ou,
no mais tardar, em `apagar_apos_min`. Uma limpeza periódica também remove
sobras antigas (ex.: se o add-on reiniciar no meio).

## Cookies do YouTube (quando o YouTube pede verificação)

Se o download falhar com “Sign in to confirm you're not a bot”, exporte os
cookies do navegador (formato Netscape) para um dos locais:

- `/share/youtube-cookies.txt` (pasta `share` do HA — já mapeada no add-on), ou
- `/data/cookies.txt`, ou
- aponte o caminho na opção `youtube.cookies`.

Veja `youtube-telegram/DOCS.md` para todas as opções.

## Antes de publicar

Troque o placeholder `SEU_USUARIO` pela sua conta do GitHub nestes arquivos:

- `repository.yaml` (campo `url`)
- `youtube-telegram/config.yaml` (campo `url`)
- `youtube-telegram/Dockerfile` (label `org.opencontainers.image.source`)

## Testar no PC (sem Home Assistant)

O programa lê as opções de `/data/options.json`, mas dá para apontar para outro
arquivo com a variável `YT_OPTIONS`:

```bash
cd youtube-telegram
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
# crie um options.json com o mesmo formato das opções do add-on e:
YT_OPTIONS=$PWD/options.json YT_DATA_DIR=$PWD python main.py
```

Precisa do `ffmpeg` instalado para juntar vídeo+áudio e converter em MP3.
# ha-addon-youtube
