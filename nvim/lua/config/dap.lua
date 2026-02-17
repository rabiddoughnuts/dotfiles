local dap = require("dap")

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

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
