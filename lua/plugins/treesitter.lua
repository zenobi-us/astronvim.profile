-- Treesitter for syntax parsing and highlighting
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "toml",
      "bash",
      "kdl",
      "graphql",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      disable = function(_, bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        return path:match("/%.memory/research/") ~= nil
      end,
    },
  },
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local path = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(path, ":t")
      return filename:match(".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  config = function(_, opts)
    local treesitter = require "nvim-treesitter.configs"
    local start_treesitter = vim.treesitter.start
    vim.treesitter.start = function(bufnr, ...)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path:match("/%.memory/research/") then return false end
      return start_treesitter(bufnr, ...)
    end
    treesitter.setup(opts)
    -- Neovim 0.12 can leave a stale markdown injection node while the
    -- generated research notes are being parsed. The treesitter highlighter
    -- then calls `range()` on that node during redraw, so use Vim's native
    -- markdown syntax highlighting for these generated notes instead.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path:match("/%.memory/research/") then vim.treesitter.stop(args.buf) end
      end,
      desc = "Avoid treesitter races in generated research notes",
    })
  end,
}
