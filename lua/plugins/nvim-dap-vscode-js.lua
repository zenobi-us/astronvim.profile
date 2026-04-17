-- Plugin: nvim-dap-vscode-js
-- Description: JavaScript/TypeScript debug adapters (pwa-node, etc.) for nvim-dap
-- URL: https://github.com/mxsdev/nvim-dap-vscode-js
---@type LazySpec
return {
  "mxsdev/nvim-dap-vscode-js",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap_vscode_js = require "dap-vscode-js"

    dap_vscode_js.setup {
      debugger_cmd = { vim.fn.expand "~/.local/share/nvim/mason/bin/js-debug-adapter" },
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    }

    local dap = require "dap"
    -- VS Code launch.json often uses type = "node" for attach; map it to pwa-node.
    dap.adapters.node = dap.adapters["pwa-node"]

    local ok, dap_ext = pcall(require, "dap.ext.vscode")
    if not ok then return end

    local lang_map = {
      ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      ["node"] = { "javascript", "typescript" },
    }

    local cwd_launch = vim.fn.getcwd() .. "/.vscode/launch.json"
    if vim.uv.fs_stat(cwd_launch) then dap_ext.load_launchjs(cwd_launch, lang_map) end

    local public_site_launch = vim.fn.getcwd() .. "/apps/public-site/.vscode/launch.json"
    if vim.uv.fs_stat(public_site_launch) then dap_ext.load_launchjs(public_site_launch, lang_map) end
  end,
}
