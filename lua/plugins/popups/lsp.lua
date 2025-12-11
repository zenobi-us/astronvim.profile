local M = {}

M.menus = {
  label = "LSP Actions",
  condition = function(predicate) return predicate.lsp_attached end,
  items = {
    {
      label = "LSP: hover",
      command = "<leader>ld",
      modes = { "n", "v" },
    },
    {
      label = "LSP: rename",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>lr",
    },
    {
      label = "LSP: code action",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>la",
    },
    {
      label = "LSP: diagnostics",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>ld",
    },
    {
      label = "LSP: references",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>lr",
    },
    {
      label = "LSP: definition",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>ld",
    },
    {
      label = "LSP: type definition",
      condition = function(predicate) return predicate.buf_has_lsp end,
      command = "<leader>lt",
    },
  },
}

return M
