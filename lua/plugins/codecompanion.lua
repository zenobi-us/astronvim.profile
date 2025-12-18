-- Lazy.nvim
return {
  {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "ravitemer/mcphub.nvim"
  }
 },
  {
      "HakonHarnes/img-clip.nvim",
      opts = {
          filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
        },
  },
}

