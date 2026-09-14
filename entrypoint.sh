#!/bin/bash
set -e
export HF_HOME=/library/.cache
OCR_INTERVAL="${OCR_INTERVAL:-300}"

ocr_pending() {
  # any /library/Manga/chNNN folder with images but no volume.html yet
  find /library -mindepth 2 -maxdepth 2 -type d | while read -r dir; do
    if ls "$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.png "$dir"/*.webp >/dev/null 2>&1; then
      if [ ! -f "$dir/volume.html" ]; then
        echo "[ocr] processing $dir"
        mokuro "$dir" || echo "[ocr] FAILED: $dir"
      fi
    fi
  done
}

if [ "$1" = "serve" ]; then
  echo "[serve] library at http://0.0.0.0:8080 (OCR every ${OCR_INTERVAL}s)"
  while true; do
    ocr_pending
    sleep "$OCR_INTERVAL"
  done &
  cd /library
  exec python3 -m http.server 8080 --bind 0.0.0.0
fi

exec "$@"
