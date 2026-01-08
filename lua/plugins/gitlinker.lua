-- Generate GitHub permalinks for code selections
---@type LazySpec
return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local gitlinker = require "gitlinker"

    -- Detect if running in WSL
    local function is_wsl()
      local version_file = io.open("/proc/version", "r")
      if version_file then
        local version = version_file:read "*a"
        version_file:close()
        return version:lower():match "microsoft" ~= nil
      end
      return false
    end

    -- Configure gitlinker with WSL-aware browser opener
    gitlinker.setup {
      callbacks = {
        ["github.com"] = require("gitlinker.hosts").get_github_type_url,
        ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        ["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
        ["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
        ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
        ["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
        ["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
        ["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
        ["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
        ["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
        ["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
      },
      opts = {
        action_callback = function(url)
          -- Copy to clipboard
          vim.fn.setreg("+", url)
          -- Open in browser (WSL-aware)
          if is_wsl() then
            -- Use Windows browser opener from WSL
            vim.fn.jobstart({ "cmd.exe", "/c", "start", url }, { detach = true })
          else
            -- Use default opener on native Linux
            vim.fn.jobstart({ "xdg-open", url }, { detach = true })
          end
          vim.notify("Copied URL to clipboard and opened in browser: " .. url)
        end,
      },
    }

    vim.keymap.set(
      { "n", "v" },
      "<leader>gy",
      function() require("gitlinker").get_buf_range_url "n" end,
      { silent = true, desc = "Get GitHub URL for selection" }
    )

    vim.keymap.set(
      { "n", "v" },
      "<leader>go",
      function() require("gitlinker").get_buf_range_url "n" end,
      { silent = true, desc = "Open buffer in GitHub" }
    )
  end,
}
