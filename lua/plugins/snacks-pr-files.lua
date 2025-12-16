return {
  "folke/snacks.nvim",
  optional = true,
  init = function()
    local Snacks = require("snacks")

    ---@type fun(): table[]
    local function get_pr_files()
      local handle = io.popen("gh pr view --json files --jq '.files[] | [.path, .additions, .deletions, .changeType] | @tsv' 2>/dev/null")
      if not handle then return {} end

      local result = {}
      for line in handle:lines() do
        local path, additions, deletions, changeType = line:match("^([^\t]+)\t([^\t]+)\t([^\t]+)\t(.+)$")
        if path then
          table.insert(result, {
            path = path,
            additions = tonumber(additions) or 0,
            deletions = tonumber(deletions) or 0,
            changeType = changeType,
          })
        end
      end
      handle:close()
      return result
    end

    ---@param item table
    ---@return string
    local function format_file_entry(item)
      local status_icon = {
        ADDED = "✚",
        DELETED = "✕",
        MODIFIED = "~",
        RENAMED = "→",
      }
      local icon = status_icon[item.changeType] or "?"
      local changes = string.format("+%d/-%d", item.additions, item.deletions)
      return string.format("%s %-40s %s", icon, item.path, changes)
    end

    local function open_pr_files()
      local files = get_pr_files()
      if #files == 0 then
        vim.notify("No PR files found or not in a PR branch", vim.log.levels.WARN)
        return
      end

      Snacks.picker.pick({
        items = files,
        format = format_file_entry,
        preview = function(item)
          return {
            title = item.path,
            cmd = function(buf)
              local file_info = string.format("Changes: +%d lines, -%d lines | Status: %s",
                item.additions, item.deletions, item.changeType)
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, { file_info, "" })
            end,
          }
        end,
        confirm = function(item)
          vim.cmd("edit " .. vim.fn.fnameescape(item.path))
        end,
      })
    end

    vim.keymap.set("n", "<leader>gf", open_pr_files, { desc = "PR Files" })
  end,
}
