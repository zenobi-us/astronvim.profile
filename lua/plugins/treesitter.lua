-- Treesitter for syntax parsing and highlighting
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local path = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(path, ":t")
      return filename:match(".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "toml",
      "bash",
      "kdl",
    },
  },
}
