# YouTube para Telegram

Add-on do Home Assistant que baixa vídeos e áudios do YouTube e entrega **direto
no seu Telegram**. Você manda um link, escolhe o formato e recebe o arquivo no
chat — sem sair do celular.

- Oferece **duas opções de vídeo** (sempre salvo em **MP4**) e **duas de áudio**
  (sempre salvo em **MP3**) por link.
- Mostra o **progresso** do download e da conversão na mesma mensagem.
- Envia no chat os arquivos de até **50 MB** (limite do Telegram).
- Arquivos maiores são enviados para o seu **MinIO** e entregues por um
  **link temporário**, apagado depois.

> É um bot do Telegram **exclusivo para isso**, separado de qualquer outro bot
> que você já use.

## Requisitos

- Home Assistant **OS** ou **Supervised** (são os que aceitam add-ons).
- Um **bot no Telegram** (grátis) — veja o passo 1 abaixo.
- Internet no Home Assistant.
- Opcional: um servidor **MinIO** para arquivos grandes.

## Instalação

### 1. Crie seu bot no Telegram

1. Abra o [@BotFather](https://t.me/BotFather) e envie `/newbot`.
2. Escolha um nome e um usuário para o bot.
3. Copie o **token** que ele te envia (algo como `123456789:AA...`).

### 2. Descubra o seu ID do Telegram

Fale com o [@userinfobot](https://t.me/userinfobot) e copie o campo `Id`.
É com ele que você libera o acesso ao seu bot.

### 3. Adicione este repositório no Home Assistant

1. No Home Assistant, vá em **Configurações → Add-ons → Loja de add-ons**.
2. Clique no menu **⋮ (três pontinhos)** → **Repositórios**.
3. Cole a URL abaixo e clique em **Adicionar**:

   ```
   https://github.com/marcosviniciuscl/ha-addon-youtube
   ```

4. Feche a janela e recarregue a página. O add-on **YouTube para Telegram**
   vai aparecer na loja.

### 4. Instale e configure

1. Abra o add-on e clique em **Instalar**.
2. Na aba **Configuração**, preencha pelo menos:

   ```yaml
   telegram_token: "SEU_TOKEN_DO_BOTFATHER"
   usuarios_autorizados:
     - SEU_ID
   ```

3. Clique em **Salvar** e depois em **Iniciar**.
4. No Telegram, mande `/start` para o seu bot e envie um link do YouTube.

Pronto — o bot já está funcionando.

## Como usar

- Envie um link (`youtube.com`, `youtu.be`, Shorts, etc.).
- O bot mostra o título, a duração e os botões de formato.
- Toque em um formato; o progresso aparece na própria mensagem.
- O arquivo chega no chat (até 50 MB) ou como link do MinIO (acima disso).
- Comandos: `/start`, `/help` e `/id` (mostra seu ID).

## Configuração

### Telegram

| Opção | Para que serve |
| --- | --- |
| `telegram_token` | Token do bot, do BotFather. **Obrigatório.** |
| `usuarios_autorizados` | IDs que podem usar o bot. Se ficar vazio, qualquer pessoa pode usar. |
| `aceitar_grupos` | Se `true`, o bot também responde em grupos. |

### YouTube

| Opção | Padrão | Para que serve |
| --- | --- | --- |
| `youtube.ativo` | `true` | Liga/desliga os downloads. |
| `youtube.altura_maxima` | `1080` | Qualidade máxima de vídeo oferecida (144–2160). |
| `youtube.duracao_maxima_min` | `120` | Duração máxima do vídeo, em minutos. |
| `youtube.mp3_bitrate_kbps` | `192` | Qualidade do MP3 (64–320). |
| `youtube.cookies` | — | Caminho de um arquivo de cookies (veja abaixo). |

### Envio pelo Telegram

| Opção | Padrão | Para que serve |
| --- | --- | --- |
| `telegram.tamanho_maximo_mb` | `50` | Limite para enviar direto no chat. Acima disso, usa o MinIO. |

### MinIO (arquivos grandes)

| Opção | Padrão | Para que serve |
| --- | --- | --- |
| `minio.ativo` | `false` | Liga o uso do MinIO. |
| `minio.endpoint` | — | Endereço, com `http(s)://` e porta se houver. |
| `minio.access_key` | — | Chave de acesso. |
| `minio.secret_key` | — | Chave secreta. |
| `minio.bucket` | `youtube-telegram` | Nome do bucket (criado se não existir). |
| `minio.secure` | `true` | Usa HTTPS. |
| `minio.regiao` | — | Região S3 (MinIO costuma aceitar `us-east-1`). |
| `minio.url_expira_min` | `60` | Validade do link temporário, em minutos. |
| `minio.apagar_apos_min` | `70` | Quando o arquivo é apagado do MinIO. |

### Registro de logs

| Opção | Padrão | Para que serve |
| --- | --- | --- |
| `log.nivel` | `INFO` | `DEBUG`, `INFO`, `WARNING` ou `ERROR`. |

## Arquivos grandes (MinIO)

O Telegram só deixa bots enviarem arquivos de até **50 MB**. Para arquivos
maiores, ative o MinIO em **Configuração**:

```yaml
minio:
  ativo: true
  endpoint: "https://minio.seudominio.com"
  access_key: "SUA_ACCESS_KEY"
  secret_key: "SUA_SECRET_KEY"
  bucket: "youtube-telegram"
  secure: true
  url_expira_min: 60
  apagar_apos_min: 70
```

Como funciona:

1. O arquivo é enviado ao seu MinIO.
2. O bot manda um **link temporário** junto com um botão
   **“🗑 Já baixei — apagar agora”**.
3. O arquivo é apagado quando você toca no botão ou, no mais tardar, depois de
   `apagar_apos_min` minutos.

O bucket é criado automaticamente se não existir e pode continuar **privado** —
o link é assinado e temporário.

## Quando o YouTube pede verificação

Se o download falhar com a mensagem *“Sign in to confirm you're not a bot”*,
exporte os cookies do seu navegador para um arquivo no formato **Netscape
(cookies.txt)** e coloque em um destes locais:

- `/share/youtube-cookies.txt` (recomendado), ou
- `/data/cookies.txt`, ou
- aponte o caminho na opção `youtube.cookies`.

Uma extensão de navegador como *Get cookies.txt* ajuda a exportar o arquivo.

## Problemas comuns

| Situação | O que fazer |
| --- | --- |
| O bot não responde | Confira o `telegram_token` e veja o **Log** do add-on. |
| “Não autorizado” | Adicione seu ID em `usuarios_autorizados` (use `/id` para ver). |
| “Passa do limite do Telegram” e o MinIO está desligado | Ative o MinIO ou escolha uma qualidade/áudio menor. |
| “Sign in to confirm you're not a bot” | Configure os cookies (seção acima). |
| Vídeo longo é recusado | Ajuste `youtube.duracao_maxima_min`. |

## Atualizar o add-on

Quando sair uma versão nova:

1. Vá em **Configurações → Add-ons → Loja de add-ons** e clique em
   **Verificar atualizações** (ou recarregue a página).
2. Abra o add-on e clique em **Atualizar**.

Se o botão **Atualizar** não aparecer, use **Reconstruir (Rebuild)** na página
do add-on.

## Observações

- Os arquivos baixados ficam em uma pasta temporária dentro do add-on e são
  apagados ao final de cada download.
- O add-on precisa de internet para falar com o Telegram e com o YouTube.
- Para ver todas as opções no detalhe, consulte a aba **Documentação** do
  add-on (arquivo `DOCS.md`).
