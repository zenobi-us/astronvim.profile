return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    suppressed_dirs = {
      "~/",
      "~/Projects",
      "~/Downloads",
      "/",
    },
    auto_session_suppress_dirs = {
      "~/",
      "~/Projects",
      "~/Downloads",
    },
    auto_restore_enabled = true,
    auto_save_enabled = true,
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
    session_lens = {
      previewer = false,
      theme_conf = { border = true },
      buftypes_to_ignore = {},
    },
  },
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<cr>", desc = "Restore session" },
    { "<leader>ws", "<cmd>SessionSave<cr>", desc = "Save session" },
    { "<leader>wl", "<cmd>SessionSearch<cr>", desc = "Search sessions" },
    { "<leader>wd", "<cmd>SessionDelete<cr>", desc = "Delete session" },
  },
}
