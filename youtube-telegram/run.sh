#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Iniciando YouTube para Telegram…"
exec python3 -u /app/main.py
