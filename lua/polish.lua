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

-- Shift+Arrow keys for line/character selection in normal and insert mode
-- Normal mode: Shift+Up/Down selects text
vim.keymap.set("n", "<S-Up>", "vk", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", "vj", { noremap = true, silent = true })

-- Visual mode: Shift+Up/Down continues selection
vim.keymap.set("v", "<S-Up>", "k", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Down>", "j", { noremap = true, silent = true })

-- Insert mode: Shift+Up/Down selects text and exits insert mode
vim.keymap.set("i", "<S-Up>", "<Esc>vk", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Down>", "<Esc>vj", { noremap = true, silent = true })

-- Shift+Ctrl+Arrow keys for word selection expansion
-- Normal mode: Shift+Ctrl+Left/Right selects by word
vim.keymap.set("n", "<S-C-Left>", "vb", { noremap = true, silent = true })
vim.keymap.set("n", "<S-C-Right>", "vw", { noremap = true, silent = true })

-- Visual mode: Shift+Ctrl+Arrow continues word selection
vim.keymap.set("v", "<S-C-Left>", "b", { noremap = true, silent = true })
vim.keymap.set("v", "<S-C-Right>", "w", { noremap = true, silent = true })

-- Insert mode: Shift+Ctrl+Arrow selects by word and exits insert mode
vim.keymap.set("i", "<S-C-Left>", "<Esc>vb", { noremap = true, silent = true })
vim.keymap.set("i", "<S-C-Right>", "<Esc>vw", { noremap = true, silent = true })
