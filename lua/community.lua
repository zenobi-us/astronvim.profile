-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.recipes.vscode-icons" },
  { import = "astrocommunity.recipes.picker-nvchad-theme" },

  { import = "astrocommunity.search.grug-far-nvim" },
  { import = "astrocommunity.utility.lua-json5" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.colorscheme.nightfox-nvim" },
  { import = "astrocommunity.keybinding.mini-clue" },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },

  -- import/override with your plugins folder
}
