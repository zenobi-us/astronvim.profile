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
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    default_component_configs = {
      -- Hide date/time and size columns
      created = { enabled = false },
      last_modified = { enabled = false },
      file_size = { enabled = false },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { link = "Comment" })
  end,
}
