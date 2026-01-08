-- LSP signature help popup
---@type LazySpec
return {
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  enabled = false,
  config = function() require("lsp_signature").setup() end,
}
