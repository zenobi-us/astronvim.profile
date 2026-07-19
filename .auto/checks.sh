#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

luajit -e 'assert(loadfile("lua/custom/dashboard-logo.nvim/lua/dashboard-logo/init.lua")); assert(loadfile("lua/custom/dashboard-logo.nvim/lua/dashboard-logo/snacks.lua")); assert(loadfile("lua/custom/dashboard-logo.nvim/lua/dashboard-logo/effects/glitch.lua")); assert(loadfile("lua/custom/dashboard-logo.nvim/lua/dashboard-logo/logos/init.lua"))'
lua lua/custom/dashboard-logo.nvim/tests/generate.lua >/dev/null
nvim --headless -u NONE -l lua/custom/dashboard-logo.nvim/tests/snacks.lua >/dev/null 2>&1
git diff --check
