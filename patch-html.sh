#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
LIB="${LOCAL_LIB:-$HERE/library}"

python3 - "$LIB" <<'EOF'
import sys, pathlib

lib = pathlib.Path(sys.argv[1])
MARK = "<!-- fit-patch -->"
CSS = "<style>html,body{position:fixed!important;inset:0!important;width:100%!important;height:100%!important;overflow:hidden!important;overscroll-behavior:none!important;}</style>"
JS = '<script>window.addEventListener("load",function(){setTimeout(function(){try{typeof zoomFitToScreen=="function"&&zoomFitToScreen()}catch(e){}},300)});</script>'

files = list(lib.rglob("*.html"))
patched = 0
for f in files:
    s = f.read_text(encoding="utf-8")
    if MARK in s:
        continue
    s = s.replace("</body>", CSS + JS + MARK + "</body>", 1)
    f.write_text(s, encoding="utf-8")
    patched += 1
print(f"patched {patched}/{len(files)} html files")
EOF
