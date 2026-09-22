# omarchy-vibrance

Saturation-boost toggle for [Omarchy](https://omarchy.org/) (Hyprland),
with a bar widget and a keybinding.

Works via Hyprland's own `decoration:screen_shader` — a GLSL fragment
shader applied at the compositor level. Unlike NVIDIA's Digital Vibrance,
this works regardless of which GPU is driving your display, which matters
on hybrid/Optimus laptops where the panel is often wired to the iGPU, not
the discrete GPU.

## Install

```bash
cp bin/omarchy-vibrance ~/.local/bin/
chmod +x ~/.local/bin/omarchy-vibrance

mkdir -p ~/.config/hypr/shaders
cp shaders/vibrance.frag ~/.config/hypr/shaders/

mkdir -p ~/.config/omarchy/plugins
cp -r plugins/bwzkk.vibrance ~/.config/omarchy/plugins/
omarchy-shell shell rescanPlugins
```

Add the widget to your bar (`~/.config/omarchy/shell.json`, under
`bar.layout.right` or any section):

```json
{ "id": "bwzkk.vibrance" }
```

Optional keybinding (`~/.config/hypr/bindings.lua`):

```lua
o.bind("SUPER + SHIFT + V", "Toggle vibrance", "omarchy-vibrance toggle")
```

## Usage

- Bar icon: click to toggle, scroll to adjust strength (clamped 1.0-3.0).
- CLI: `omarchy-vibrance {on|off|toggle|status|inc|dec}`
- Edit the `saturation` constant in `~/.config/hypr/shaders/vibrance.frag`
  to change the default.

## How it works

`omarchy-vibrance` shells out to `hyprctl eval` to set
`decoration:screen_shader` at runtime (Hyprland's Lua config parser needs
`eval`, not `keyword`). The shader mixes each pixel toward grayscale by a
negative amount to boost saturation. The bar widget polls
`omarchy-vibrance status` (which prints `<on|off> <saturation>`) and shells
out on click/scroll, following the same pattern as Omarchy's own
first-party toggle widgets.
