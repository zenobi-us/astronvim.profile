# dashboard-logo.nvim

Animated ANSI-art logos for Neovim dashboards and terminal previews.

`dashboard-logo.nvim` parses true-colour ANSI logos, applies animated effects, and renders the same output through either Snacks.nvim or a standalone Lua CLI. The default glitch effect uses a green CRT palette. A custom base colour can be supplied without losing the original palette's luminance gradient.

## Install

### lazy.nvim

Use the plugin from a local checkout:

```lua
{
  "dashboard-logo.nvim",
  dir = vim.fn.stdpath("config") .. "/lua/custom/dashboard-logo.nvim",
  dependencies = { "folke/snacks.nvim" },
}
```

The standalone renderer requires a Lua interpreter. Animated CLI previews also require `stty` and `sleep`.

## Usage

### Snacks.nvim

```lua
local dashboard_logo = require("dashboard-logo.snacks").setup {
  effect = "glitch",
  color = vim.api.nvim_get_hl(0, { name = "Special", link = false }).fg,
  update = function()
    require("snacks").dashboard.update()
  end,
}

require("snacks").setup {
  dashboard = {
    sections = {
      dashboard_logo.section,
      { section = "startup" },
    },
  },
}
```

`color` accepts either a `#rrggbb` string or a Neovim highlight colour integer. Omit it to use the default green palette.

Stop the animation timer when needed:

```lua
dashboard_logo.stop()
```

### Core renderer

The core module has no Neovim dependency:

```lua
local logo = require "dashboard-logo"

local animation = logo.new {
  logo = "grudge_axe",
  effect = "glitch",
  color = "#c678dd",
  update = function(frame)
    -- Render frame through another frontend.
  end,
}

local frame = animation.frame()
animation.tick()
```

Available built-in effects:

- `glitch` — animated scan bands, displacement, and burn waves.
- `none` — unchanged logo frame.

## API

### `require("dashboard-logo")`

#### `render(name?) -> frame`

Parses a named logo into lines and colour segments. Uses the default logo when `name` is omitted.

#### `generate(state?, name?, effect?) -> frame`

Renders one frame using the supplied mutable effect state.

```lua
local state = { color = "#61afef" }
local frame = logo.generate(state, "grudge_axe", "glitch")
```

#### `advance(state?, name?, effect?) -> state`

Advances effect state by one animation step.

#### `new(opts?) -> animation`

Creates an animation object.

| Option | Type | Description |
| --- | --- | --- |
| `logo` | `string` | Registered logo name. |
| `effect` | `string` | Registered effect name. Defaults to `glitch`. |
| `color` | `string` | Effect base colour in `#rrggbb` format. |
| `update` | `function(frame)` | Called after each `tick()`. |

Returned animation fields:

| Field | Description |
| --- | --- |
| `interval` | Effect interval in milliseconds. |
| `frame()` | Returns current frame without advancing state. |
| `tick()` | Advances state, calls `update`, and returns new frame. |

#### `filter_color(source?, filter?) -> color?`

Tints a source colour with an effect filter while retaining source shading.

#### `logos`

Table of registered logos. `logos.default` contains the default logo name.

#### `effects`

Table of registered effects. `effects.default` contains the default effect name.

### `require("dashboard-logo.snacks")`

#### `setup(opts?) -> integration`

Creates a Snacks dashboard section. Its first render starts the animation timer. Supports `logo`, `effect`, `color`, `on_frame`, and `update` options. Neovim integer colours are converted to `#rrggbb` before reaching the core renderer.

The adapter renders logo highlights in its own namespace. Color-only frames update those extmarks directly. Single-pane geometry glitches update only the logo's buffer rows; multi-pane layouts fall back to `update(frame)` for a full Snacks rebuild. `on_frame(frame)` runs after every frame.

Returns:

- `section()` — Snacks dashboard section provider.
- `stop()` — stops and closes the animation timer.

#### `stop()`

Stops the active global dashboard-logo timer.

## CLI

Render one frame:

```sh
./cli.lua
```

Run an animated preview:

```sh
./cli.lua --watch
```

Use another effect or colour:

```sh
./cli.lua --watch --effect=glitch --color=#c678dd
./cli.lua --effect=none
```

| Option | Description |
| --- | --- |
| `-w`, `--watch` | Keep rendering frames until interrupted. |
| `--effect=NAME` | Select an effect. Defaults to `glitch`. |
| `--color=#rrggbb` | Set glitch base colour. Defaults to the original green palette. |

Watch mode reloads dashboard-logo Lua modules before every frame, allowing logo and effect edits without restarting the process. Press `Ctrl-C` to stop it.
