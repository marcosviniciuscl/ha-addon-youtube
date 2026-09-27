ARG BUILD_VERSION="1.0.0"
ARG BUILD_ARCH="amd64"

FROM ghcr.io/home-assistant/base:latest

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="aarch64|amd64|armv7|armhf" \
  org.opencontainers.image.title="YouTube para Telegram" \
  org.opencontainers.image.description="Baixa vídeos e áudios do YouTube pelo Telegram, entrega no chat e usa o MinIO para arquivos grandes." \
  org.opencontainers.image.source="https://github.com/SEU_USUARIO/ha-addon-youtube" \
  org.opencontainers.image.licenses="MIT"

# ffmpeg é necessário para juntar vídeo+áudio e para converter em MP3.
RUN apk add --no-cache python3 py3-pip ffmpeg

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir --break-system-packages -r /app/requirements.txt

COPY . /app
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
