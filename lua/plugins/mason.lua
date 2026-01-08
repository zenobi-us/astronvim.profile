-- Package manager for language servers, formatters, and linters
---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "eslint-lsp",
        "json-lsp",
        "tailwindcss-language-server",
        "vtsls",

        -- install debuggers
        "debugpy",
      },
      -- Suppress errors for optional tools that may not be available
      auto_update = true,
      run_on_start = true,
    },
  },
}
