-- Plugin: mason-lspconfig.nvim
-- Description: Bridge Mason v2 to AstroLSP through Neovim's native LSP API
-- URL: https://github.com/mason-org/mason-lspconfig.nvim
---@type LazySpec
return {
  "williamboman/mason-lspconfig.nvim",
  version = "^2",
  commit = "b3298993d55fa194279b5eb9dbfb3a43da65cadf",
  pin = true,
  opts = function(_, opts)
    opts.automatic_enable = false
    opts.handlers = nil
  end,
  config = function(plugin, opts)
    require("astronvim.plugins.configs.mason-lspconfig")(plugin, opts)

    local default_config = vim.lsp.config["*"] or {}
    local existing_before_init = default_config.before_init
    vim.lsp.config("*", {
      before_init = function(params, config)
        local ok, codesettings = pcall(require, "codesettings")
        if ok and config.name then codesettings.with_local_settings(config.name, config) end
        if existing_before_init then existing_before_init(params, config) end
      end,
    })

    local astrolsp = require "astrolsp"
    for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
      astrolsp.lsp_setup(server)
    end
  end,
}
