-- Base nvim-dap adapter and launch configuration.
local dap = require("dap")

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

-- Only TypeScript has an explicit launch profile here; other languages rely on future expansion.
dap.configurations.typescript = {
  {
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
  },
}
