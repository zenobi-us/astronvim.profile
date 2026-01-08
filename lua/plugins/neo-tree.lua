-- File tree explorer with document symbols
---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  opts = {
    source_selector = {
      winbar = false,
      statusline = false,
    },
    sources = { "filesystem", "document_symbols" },
  },
}
