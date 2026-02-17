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

for server, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
