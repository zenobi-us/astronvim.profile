return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufRead",
    config = function()
      require("scrollbar").setup({
        handlers = {
          diagnostic = true,
          gitsigns = true,
          search = true,
        },
      })
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar.handlers.diagnostic").setup()
    end,
  },
}
