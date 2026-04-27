local function CreateGitBranchWidget()
  local hl = require "astroui.status.hl"

  local GitBranchWidget = {}

  local function fallback_git_branch()
    -- 1) Current buffer branch (normal files)
    local current = vim.b.gitsigns_head
    if current and current ~= "" then return current end

    -- 2) Any loaded listed buffer branch (works when focused in neo-tree)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buflisted then
        local head = vim.b[bufnr].gitsigns_head
        if head and head ~= "" then return head end
      end
    end

    -- 3) Last resort: resolve from cwd (handles neo-tree-only session)
    local out = vim.fn.systemlist { "git", "-C", vim.fn.getcwd(), "rev-parse", "--abbrev-ref", "HEAD" }
    if vim.v.shell_error == 0 and out[1] and out[1] ~= "HEAD" and out[1] ~= "" then return out[1] end

    return ""
  end

  GitBranchWidget.provider = function()
    local branch = fallback_git_branch()
    return branch ~= "" and " " .. branch or ""
  end

  GitBranchWidget.hl = function() return hl.get_attributes "git_branch" end

  GitBranchWidget.on_click = {
    name = "heirline_branch",
    callback = function()
      local fzf_lua_avail, fzf_lua = pcall(require, "fzf-lua")
      if fzf_lua_avail then
        fzf_lua.git_branches()
        return
      end

      local telescope_avail, telescope_builtin = pcall(require, "telescope.builtin")
      if telescope_avail then
        telescope_builtin.git_branches { use_file_path = true }
        return
      end

      local snacks_avail, snacks = pcall(require, "snacks")
      if snacks_avail then
        snacks.picker.git_branches()
        return
      end
    end,
  }

  return GitBranchWidget
end

return {
  CreateGitBranchWidget = CreateGitBranchWidget,
}
