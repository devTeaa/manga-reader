#!/bin/bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
[ -f "$HERE/.env" ] && . "$HERE/.env"

: "${VPS_HOST:?set VPS_HOST in .env}"
: "${VPS_PORT:?set VPS_PORT in .env}"
: "${VPS_USER:?set VPS_USER in .env}"
: "${VPS_DIR:?set VPS_DIR in .env}"
LOCAL_LIB="${LOCAL_LIB:-$HERE/library}"

[ -d "$LOCAL_LIB" ] || { echo "no library at $LOCAL_LIB"; exit 1; }

echo "syncing library -> $VPS_USER@$VPS_HOST:$VPS_DIR/library"
# --delete mirrors exactly (chapters removed locally are removed on vps)
rsync -az --delete --info=stats1 \
  -e "ssh -p $VPS_PORT" \
  --exclude='.cache' \
  "$LOCAL_LIB/" "$VPS_USER@$VPS_HOST:$VPS_DIR/library/"

echo "done"
