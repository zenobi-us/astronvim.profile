-- Plugin: heirline.nvim
-- Description: Statusline, winbar, and tabline UI components
-- URL: https://github.com/rebelot/heirline.nvim

local CreateGitBranchWidget = require("custom.heirlein.widgets.GitBranchWidget").CreateGitBranchWidget

---@type LazySpec
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      --
      -- Left
      --
      status.component.mode(),
      CreateGitBranchWidget(),
      status.component.file_info(),
      status.component.git_diff(),
      status.component.diagnostics(),

      -- Spacer
      status.component.fill(),

      --
      -- Center
      --
      status.component.cmd_info(),

      -- Spacer
      status.component.fill(),

      --
      -- Right
      --
      status.component.lsp(),
      status.component.virtual_env(),
      status.component.treesitter(),
      status.component.nav(),
      status.component.mode { surround = { separator = "right" } },
    }

    return opts
  end,
}
