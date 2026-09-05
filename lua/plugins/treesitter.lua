-- Treesitter for syntax parsing and highlighting
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local path = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(path, ":t")
      return filename:match(".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  config = function()
    local treesitter = require "nvim-treesitter"
    treesitter.setup()
    treesitter.install {
      "lua",
      "vim",
      "toml",
      "bash",
      "kdl",
      "graphql",
    }
  end,
}
