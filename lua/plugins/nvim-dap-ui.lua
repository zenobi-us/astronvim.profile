return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    -- Setup dapui with default config
    dapui.setup()

    -- Open/close dapui automatically with debugger
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end

    -- Keymaps for dapui
    local keymap = vim.keymap.set
    keymap("n", "<Leader>du", dapui.toggle, { desc = "Toggle Debugger UI" })
    keymap("n", "<Leader>dE", dapui.eval, { desc = "Evaluate expression" })
  end,
}
