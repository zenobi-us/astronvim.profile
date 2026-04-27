-- Plugin: minuet-ai.nvim
-- Description: AI code completion via local LM Studio (OpenAI-compatible)
-- URL: https://github.com/milanglacier/minuet-ai.nvim
---@type LazySpec
return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    config = function(_, opts) require("minuet").setup(opts) end,
    opts = {
      provider = "openai_compatible",
      request_timeout = 2.5,
      throttle = 1000,
      debounce = 400,
      n_completions = 1,
      context_window = 512,
      virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
          accept = "<A-Right>",
          accept_line = "<A-Down>",
          accept_n_lines = "<A-z>",
          prev = "<M-[>",
          next = "<M-]>",
          dismiss = "<C-]>",
        },
      },
      provider_options = {
        openai_compatible = {
          name = "LM Studio",
          api_key = "TERM", -- dummy env var for local endpoint
          end_point = "http://127.0.0.1:1234/v1/chat/completions",
          model = vim.env.LMSTUDIO_MODEL or "qwen2.5-coder-7b-instruct",
          optional = {
            max_tokens = 128,
            top_p = 0.9,
          },
        },
      },
    },
  },

  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }
      if not vim.tbl_contains(opts.sources.default, "minuet") then table.insert(opts.sources.default, "minuet") end

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = vim.tbl_deep_extend("force", opts.sources.providers.minuet or {}, {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        timeout_ms = 2500,
        score_offset = 50,
      })

      opts.completion = opts.completion or {}
      opts.completion.trigger = opts.completion.trigger or {}
      if opts.completion.trigger.prefetch_on_insert == nil then opts.completion.trigger.prefetch_on_insert = false end
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      local has_minuet = false
      for _, source in ipairs(opts.sources) do
        if source.name == "minuet" then
          has_minuet = true
          break
        end
      end
      if not has_minuet then table.insert(opts.sources, 1, { name = "minuet" }) end

      opts.performance = opts.performance or {}
      if not opts.performance.fetching_timeout or opts.performance.fetching_timeout < 2000 then
        opts.performance.fetching_timeout = 2000
      end
    end,
  },
}
