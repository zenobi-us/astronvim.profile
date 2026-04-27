local function CreateGitWorktreeWidget()
  local hl = require "astroui.status.hl"

  local GitWorktreeWidget = {}

  local function fallback_git_worktree()
    -- Resolve current repository root from cwd (works in normal buffers and neo-tree)
    local root_out = vim.fn.systemlist { "git", "-C", vim.fn.getcwd(), "rev-parse", "--show-toplevel" }
    if vim.v.shell_error ~= 0 or not root_out[1] or root_out[1] == "" then return "" end

    local root = vim.fn.fnamemodify(root_out[1], ":p"):gsub("/$", "")

    -- Try to resolve the worktree entry from git's porcelain list
    local wt_out = vim.fn.systemlist { "git", "-C", root, "worktree", "list", "--porcelain" }
    if vim.v.shell_error == 0 and wt_out and #wt_out > 0 then
      local current_worktree
      for _, line in ipairs(wt_out) do
        local path = line:match "^worktree%s+(.+)$"
        if path then
          local normalized = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
          if normalized == root then
            current_worktree = vim.fn.fnamemodify(normalized, ":t")
            break
          end
        end
      end
      if current_worktree and current_worktree ~= "" then return current_worktree end
    end

    -- Fallback: folder name of repo root
    return vim.fn.fnamemodify(root, ":t")
  end

  GitWorktreeWidget.provider = function()
    local worktree = fallback_git_worktree()
    return worktree ~= "" and " " .. worktree or ""
  end

  GitWorktreeWidget.hl = function() return hl.get_attributes "git_branch" end

  GitWorktreeWidget.on_click = {
    name = "heirline_worktree",
    callback = function()
      local snacks_avail, snacks = pcall(require, "snacks")
      if snacks_avail and snacks.picker and snacks.picker.worktrees then
        snacks.picker.worktrees()
        return
      end

      local worktrees_avail, worktrees = pcall(require, "worktrees")
      if worktrees_avail and worktrees.switch_worktree then
        worktrees.switch_worktree()
        return
      end

      if vim.fn.exists ":GitWorktreeSwitch" == 2 then
        vim.cmd "GitWorktreeSwitch"
        return
      end
    end,
  }

  return GitWorktreeWidget
end

return {
  CreateGitWorktreeWidget = CreateGitWorktreeWidget,
}
