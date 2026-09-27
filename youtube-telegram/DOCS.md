# YouTube para Telegram

Recebe links do YouTube pelo Telegram, baixa o vídeo/áudio e devolve no chat.
Arquivos acima do limite do Telegram vão para o MinIO e são entregues por um
link temporário.

## Uso

- Mande um link (`youtube.com`, `youtu.be`, Shorts, etc.) para o bot.
- O bot mostra o título, a duração e **2 opções de vídeo + 2 de áudio**.
- Clique na opção; o progresso aparece na própria mensagem.
- O arquivo final é enviado no chat (até o limite) ou vira um link do MinIO.
- `/id` mostra seu ID (use em `usuarios_autorizados`).
- `/start` e `/help` mostram o resumo.

## Opções

### Telegram
| Opção | Descrição |
| --- | --- |
| `telegram_token` | Token do bot (BotFather). **Obrigatório.** |
| `usuarios_autorizados` | Lista de IDs que podem usar o bot. Vazio = todos. |
| `aceitar_grupos` | Se `true`, também responde em grupos. |

### YouTube
| Opção | Padrão | Descrição |
| --- | --- | --- |
| `youtube.ativo` | `true` | Liga/desliga o download. |
| `youtube.altura_maxima` | `1080` | Qualidade máxima oferecida (144–2160). |
| `youtube.duracao_maxima_min` | `120` | Duração máxima do vídeo, em minutos. |
| `youtube.mp3_bitrate_kbps` | `192` | Bitrate do MP3 (64–320). |
| `youtube.cookies` | — | Caminho de um `cookies.txt` (opcional). |

Sem a opção, o bot procura cookies em `/data/cookies.txt` e
`/share/youtube-cookies.txt`.

### Envio pelo Telegram
| Opção | Padrão | Descrição |
| --- | --- | --- |
| `telegram.tamanho_maximo_mb` | `50` | Limite do Bot API. Acima disso, usa o MinIO. |

### MinIO
| Opção | Padrão | Descrição |
| --- | --- | --- |
| `minio.ativo` | `false` | Liga o uso do MinIO. |
| `minio.endpoint` | — | `https://minio.exemplo.com[:porta]`. |
| `minio.access_key` | — | Chave de acesso. |
| `minio.secret_key` | — | Chave secreta. |
| `minio.bucket` | `youtube-telegram` | Bucket (criado se não existir). |
| `minio.secure` | `true` | Usa HTTPS. |
| `minio.regiao` | — | Região S3 (MinIO aceita `us-east-1`). |
| `minio.url_expira_min` | `60` | Validade do link pré-assinado, em minutos. |
| `minio.apagar_apos_min` | `70` | Apaga o objeto após X minutos (ou no botão). |

### Log
| Opção | Padrão | Descrição |
| --- | --- | --- |
| `log.nivel` | `INFO` | `DEBUG`, `INFO`, `WARNING` ou `ERROR`. |

Os logs saem no log do add-on (aba **Log**) e também em
`/data/youtube-telegram.log`.

## Observações

- Os arquivos baixados ficam em `/tmp` dentro do container e são apagados ao
  final de cada download.
- O bot respeita o limite de upload do Telegram (50 MB). Não há como enviar
  arquivos maiores pelo Bot API — por isso o MinIO.
- Para usar um bucket privado, nada mais é preciso: os links são pré-assinados.
