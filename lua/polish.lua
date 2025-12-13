-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Configure clipboard for WSL with win32yank or Wayland
if vim.env.WSL_DISTRO_NAME then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
else
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 0,
  }
end

-- Shift+Arrow keys for selections in normal and insert mode
-- Normal mode: Shift+Arrow selects text
vim.keymap.set("n", "<S-Left>", "vh", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", "vl", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Up>", "vk", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", "vj", { noremap = true, silent = true })

-- Visual mode: Shift+Arrow continues selection
vim.keymap.set("v", "<S-Left>", "h", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Right>", "l", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Up>", "k", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Down>", "j", { noremap = true, silent = true })

-- Insert mode: Shift+Arrow selects text and exits insert mode
vim.keymap.set("i", "<S-Left>", "<Esc>vh", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Right>", "<Esc>vl", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Up>", "<Esc>vk", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Down>", "<Esc>vj", { noremap = true, silent = true })
