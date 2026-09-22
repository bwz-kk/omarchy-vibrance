#!/bin/bash
# Installs the omarchy-vibrance plugin: CLI, shader, and bar widget.
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p ~/.local/bin ~/.config/hypr/shaders ~/.config/omarchy/plugins

cp bin/omarchy-vibrance ~/.local/bin/omarchy-vibrance
chmod +x ~/.local/bin/omarchy-vibrance

cp -n shaders/vibrance.frag ~/.config/hypr/shaders/vibrance.frag

cp -r plugins/bwzkk.vibrance ~/.config/omarchy/plugins/

python3 - <<'PY'
import json, pathlib

p = pathlib.Path.home() / ".config/omarchy/shell.json"
data = json.loads(p.read_text()) if p.exists() else {"version": 1, "bar": {"layout": {"right": []}}}
right = data.setdefault("bar", {}).setdefault("layout", {}).setdefault("right", [])
if not any(isinstance(x, dict) and x.get("id") == "bwzkk.vibrance" for x in right):
    right.append({"id": "bwzkk.vibrance"})
p.write_text(json.dumps(data, indent=2) + "\n")
PY

omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true

cat <<'EOF'

Installed. A "V" icon was added to your bar's right section.
  - click:  toggle the saturation boost
  - scroll: adjust its strength

Optional keybinding -- check the key isn't already bound first
(omarchy menu keybindings --print), then add to
~/.config/hypr/bindings.lua:

  o.bind("SUPER + SHIFT + V", "Toggle vibrance", "omarchy-vibrance toggle")
EOF
