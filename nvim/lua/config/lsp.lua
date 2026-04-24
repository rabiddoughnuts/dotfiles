-- Shared LSP setup module.
-- Note: init.lua currently leaves this module disabled because equivalent LSP
-- setup also lives inside lua/plugins/core.lua.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  clangd = {},
  html = {},
  jdtls = {},
  lua_ls = {},
  ruby_lsp = {},
  pyright = {},
  rust_analyzer = {},
  eslint = {},
  ts_ls = {},
}

-- Apply cmp capabilities consistently across every configured language server.
for server, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
