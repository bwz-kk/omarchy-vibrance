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
git clone https://github.com/bwz-kk/omarchy-vibrance.git
cd omarchy-vibrance
./install.sh
```

This copies the CLI to `~/.local/bin`, the shader to
`~/.config/hypr/shaders`, the plugin to `~/.config/omarchy/plugins`, adds
the widget to your bar's right section in `~/.config/omarchy/shell.json`
(merged in without touching your existing widgets), and rescans plugins.
Safe to re-run — it won't duplicate the bar entry or overwrite a shader
you've already tuned.

Requires `python3` (used for the one-time `shell.json` merge — ships with
Omarchy).

Optional keybinding — check the key isn't already bound first
(`omarchy menu keybindings --print`), then add to
`~/.config/hypr/bindings.lua`:

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
