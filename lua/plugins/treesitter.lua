-- Plugin: tree-sitter-manager.nvim
-- Description: Install and manage Tree-sitter parsers on Neovim 0.12+
-- URL: https://github.com/romus204/tree-sitter-manager.nvim
---@type LazySpec
return {
  "romus204/tree-sitter-manager.nvim",
  lazy = false,
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
    nohighlight = { "markdown" },
    auto_install = false,
  },
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local path = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(path, ":t")
      return filename:match(".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  config = function(_, opts)
    require("tree-sitter-manager").setup(opts)

    -- Generated research notes use Vim's native Markdown highlighting.
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
