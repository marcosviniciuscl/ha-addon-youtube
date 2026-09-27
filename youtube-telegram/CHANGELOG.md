# Changelog

## 1.0.0

- Versão inicial.
- Recebe links do YouTube pelo Telegram e oferece 2 opções de vídeo + 2 de áudio.
- Progresso do download/conversão na mesma mensagem.
- Envio direto no chat até o limite do Telegram (padrão 50 MB).
- Acima do limite, envia para o MinIO e entrega link pré-assinado temporário.
- Apaga o objeto do MinIO automaticamente (ou pelo botão) e faz limpeza periódica.
