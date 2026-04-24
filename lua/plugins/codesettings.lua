---@type LazySpec
return {
  "mrjones2014/codesettings.nvim",
  -- Recommended by plugin docs: keep this eagerly available for LSP hooks.
  lazy = false,
  dependencies = { "nvimtools/none-ls.nvim" },
  opts = {
    -- Look for these config files in your project root
    config_file_paths = { ".vscode/settings.json", "codesettings.json", "lspsettings.json" },
    -- Set filetype to jsonc when opening config files for better editing
    jsonc_filetype = true,
    -- Integrate with jsonls to provide LSP completion for LSP settings
    jsonls_integration = true,
    -- Enable live reloading of settings when config files change
    live_reload = false,
    -- Automatically set up library paths for lua_ls to pick up type annotations
    lua_ls_integration = true,
    -- How to merge lists: 'append' (default), 'prepend', or 'replace'
    merge_lists = "append",
  },
  -- Keep this plugin globally available; it lazy-loads internals itself.
}
